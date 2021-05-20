require File.expand_path('../support/test_helper', __dir__)

require 'minitest/autorun'
require 'minitest/pride'
require 'dotenv/load'

class ApiTest < Minitest::Test
  def setup
    @url = 'http://www.omdbapi.com/'
    @key = ENV['OMDb_API_KEY']
    @apikey = "apikey=#{@key}"
  end

  def test_no_api_key
    make_request('?s=star', "#{@url}")
    puts last_response
    assert_equal 'False', last_response[:Response]
    assert_equal 'No API key provided.', last_response[:Error]
  end

  def test_thomas_search_has_valid_returns
    make_request("?s=thomas&#{@apikey}", "#{@url}")
    last_response[:Search].each do |res|
      # Verify all titles are a relevant match
      assert_includes res[:Title].downcase, 'thomas'

      # Verify keys include Title, Year, imdbID, Type, and Poster for all records in the response
      assert_equal [:Title, :Year, :imdbID, :Type, :Poster], res.keys

      # Verify values are all of the correct object class
      res.keys.each do |key|
        assert_instance_of String, res[key]
      end

      # Verify year matches correct format
      assert valid_year?(res)
    end
  end

  def test_each_pg1_title_is_accessible_via_imdbID
    make_request("?s=thomas&#{@apikey}", "#{@url}")

    results = last_response[:Search]

    results.each do |res|
      make_request("?i=#{res[:imdbID]}&#{@apikey}", "#{@url}")
      assert_equal res[:Title], last_response[:Title]
    end
  end

  def test_all_pg1_poster_links_are_working
    make_request("?s=thomas&#{@apikey}", "#{@url}")
    results = last_response[:Search]

    results.each do |res|
      assert valid_uri?(res[:Poster])
    end
  end

  def test_for_duplicates_on_first_five_pgs
    results = []
    index = 1

    5.times do
      make_request("?s=thomas&page=#{index}&#{@apikey}", "#{@url}")
      results << last_response[:Search]
      index +=1
    end

    results = results.flatten

    unique_results = results.uniq {|res| res[:imdbID]}

    assert_equal 50, results.count
    assert_equal 49, unique_results.count
    refute_equal results.count, unique_results.count
  end

  def test_it_can_return_movies_w_keyword_carson_year_2020
    # testing all movies with keyword 'carson' that were released in 2020
    make_request("?s=carson&type=movie&y=2020&#{@apikey}", "#{@url}")

    assert_equal '5', last_response[:totalResults]

    last_response[:Search].each do |res|
      assert_equal 'movie', res[:Type]
      refute_equal 'series', res[:Type]

      assert_equal '2020', res[:Year]

      assert_includes res[:Title].downcase, 'carson'
    end
  end

  def test_valid_year
    good_result = {Year: "2020–"}
    assert valid_year?(good_result)

    bad_result = {Year: "sfgsr"}
    assert_equal false, valid_year?(bad_result)

    bad_result = {Year: "35435"}
    assert_equal false, valid_year?(bad_result)
  end

  def test_year_checker
    good_result = "2020"
    assert year_checker(good_result)

    bad_result = "50"
    assert_equal false, year_checker(bad_result)
  end

  def test_year_splitter
    year = "1999–2008"
    expected = %w(1 9 9 9 2 0 0 8)

    assert_equal expected, year_splitter(year)

    year = "2017–"
    expected = %w(2 0 1 7)
    assert_equal expected, year_splitter(year)
  end
end

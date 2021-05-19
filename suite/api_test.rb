require File.expand_path('../support/test_helper', __dir__)

require 'minitest/autorun'
require 'minitest/pride'

class ApiTest < Minitest::Test

  def test_no_api_key
    skip
    make_request('?s=star', 'http://www.omdbapi.com/')
    # puts last_response
    assert_equal 'False', last_response[:Response]
    assert_equal 'No API key provided.', last_response[:Error]
  end

  def test_thomas_search_has_valid_returns
    skip
  # TODO: TAKE OUT API KEY!
    make_request('?s=thomas&apikey=8d48d285', 'http://www.omdbapi.com/')
    last_response[:Search].each do |res|
      # Verify all titles are a relevant match
      assert_includes res[:Title].downcase, 'thomas'

      # Verify keys include Title, Year, imdbID, Type, and Poster for all records in the response
      assert_equal [:Title, :Year, :imdbID, :Type, :Poster], res.keys

      # Verify values are all of the correct object class
      assert_instance_of String, res[:Title]
      assert_instance_of String, res[:Year]
      assert_instance_of String, res[:imdbID]
      assert_instance_of String, res[:Type]
      assert_instance_of String, res[:Poster]

      # Verify year matches correct format
      # TODO: come back and fix this
      assert res[:Year].length >= 4
    end
  end

  def test_each_title_is_accessible_via_imdbID
    skip
    make_request('?s=thomas&page=1&apikey=8d48d285', 'http://www.omdbapi.com/')
    assert_equal 10, last_response[:Search].count
    one = last_response[:Search][0]
    two = last_response[:Search][1]
    three = last_response[:Search][2]
    four = last_response[:Search][3]
    five = last_response[:Search][4]
    six = last_response[:Search][5]
    seven = last_response[:Search][6]
    eight = last_response[:Search][7]
    nine = last_response[:Search][8]
    ten = last_response[:Search][9]

    make_request("?i=#{one[:imdbID]}&apikey=8d48d285", 'http://www.omdbapi.com/')
    assert_equal one[:imdbID], last_response[:imdbID]

    make_request("?i=#{two[:imdbID]}&apikey=8d48d285", 'http://www.omdbapi.com/')
    assert_equal two[:imdbID], last_response[:imdbID]

    make_request("?i=#{three[:imdbID]}&apikey=8d48d285", 'http://www.omdbapi.com/')
    assert_equal three[:imdbID], last_response[:imdbID]

    make_request("?i=#{four[:imdbID]}&apikey=8d48d285", 'http://www.omdbapi.com/')
    assert_equal four[:imdbID], last_response[:imdbID]

    make_request("?i=#{five[:imdbID]}&apikey=8d48d285", 'http://www.omdbapi.com/')
    assert_equal five[:imdbID], last_response[:imdbID]

    make_request("?i=#{six[:imdbID]}&apikey=8d48d285", 'http://www.omdbapi.com/')
    assert_equal six[:imdbID], last_response[:imdbID]

    make_request("?i=#{seven[:imdbID]}&apikey=8d48d285", 'http://www.omdbapi.com/')
    assert_equal seven[:imdbID], last_response[:imdbID]

    make_request("?i=#{eight[:imdbID]}&apikey=8d48d285", 'http://www.omdbapi.com/')
    assert_equal eight[:imdbID], last_response[:imdbID]

    make_request("?i=#{nine[:imdbID]}&apikey=8d48d285", 'http://www.omdbapi.com/')
    assert_equal nine[:imdbID], last_response[:imdbID]

    make_request("?i=#{ten[:imdbID]}&apikey=8d48d285", 'http://www.omdbapi.com/')
    assert_equal ten[:imdbID], last_response[:imdbID]
  end

  def test_all_poster_links_are_working
    make_request('?s=thomas&page=1&apikey=8d48d285', 'http://www.omdbapi.com/')
    assert_equal 10, last_response[:Search].count
    results = last_response[:Search]

    results.each do |res|
      assert valid_uri?(res[:Poster])
    end
  end
end

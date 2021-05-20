Encoding.default_external = Encoding::UTF_8
Encoding.default_internal = Encoding::UTF_8

require 'faraday'
require 'json'
require 'minitest/autorun'
require 'minitest/reporters'
require 'pry'
require 'uri'

def test_client
  @test_client ||= Faraday.new do |f|
    f.adapter :net_http
  end
end

def get(full_path)
  test_client.get(full_path)
end

def make_request(params, url = ENV['BASE_URL'])
  full_path = "#{url}#{params}"
  res = get(full_path)
  @last_response = JSON.parse(res.body, symbolize_names: true)
  @curl = set_curl(res)
  res
end

def last_response
  @last_response
end

def last_curl
  @curl
end

def set_curl(res)
  <<~CURL
    See: curl -X "#{res.env.method.upcase}" "#{res.env.url}"
  CURL
end

def valid_uri?(uri)
  !!(uri =~ URI.regexp)
end

def valid_year?(result)
  year = result[:Year]

  if year.to_i.to_s != year && year.to_i != 0 && year.length > 5
    year_array = []
    split_year = year_splitter(year)
    split_year.each_slice(4) {|e| year_array << e.join('')}
    year_array.each {|yr| year_checker(yr)}
  elsif year.to_i.to_s != year && year.to_i != 0
    split_year = year_splitter(year)
    year_checker(split_year.join(''))
  else
    year_checker(year)
  end
end

def year_checker(year)
  year.to_i.between?(1800, 2099)
end

def year_splitter(year)
  year.split('').delete_if {|e| e == '–'}
end

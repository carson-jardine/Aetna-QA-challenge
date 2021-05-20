# Carson Jardine - QA API Code Test

## Table of Contents
- [Challenge Overview](#challenge-overview)
- [Getting Started](#getting-started)
- [Helpful Information & Notes](#helpful-information--notes)
- [Acknowledgements](#acknowledgements)

***
## Challenge Overview:

It is time to run some tests against OMDb API - The Open Movie Database!

### Tips:

- You can find the main api page at http://www.omdbapi.com
- You must use minitest and faraday as supplied, and follow the existing pattern of api requests in test_no_api_key.
- You may add or change other gems as you see the need. (For example, 'pry' is supplied debugging but you may use another debugger.)
- Completed repo should allow for easy setup/running of your test file.
- Unique or helpful information should be documented in the readme.

### Tasks:

1. Successfully make api requests to omdbapi from within tests in api_test.rb

2. Add an assertion to test_no_api_key to ensure the response at runtime matches what is currently displayed with the api key missing

3. Extend api_test.rb by creating a test that performs a search on 'thomas'.

  - Verify all titles are a relevant match
  - Verify keys include Title, Year, imdbID, Type, and Poster for all records in the response
  - Verify values are all of the correct object class
  - Verify year matches correct format

4. Add a test that uses the i parameter to verify each title on page 1 is accessible via imdbID

5. Add a test that verifies none of the poster links on page 1 are broken

6. Add a test that verifies there are no duplicate records across the first 5 pages

7. Add a test that verifies something you are curious about with regard to movies or data in the database.

***
## Getting Started:

### Local Setup:
1. Fork and/or clone this repository.
2. `cd Aetna-QA-challenge`
3. Run `bundle install` to install gem packages.
4. Visit the [OMDb website](http://www.omdbapi.com/) to get your own API key.
5. Add your API key to the `.env` file, keep the `OMDb_API_KEY` name.  

### Testing: 
- Run tests: `ruby suite/api_test.rb`

***
## Helpful Information & Notes
- I added the gem `dotenv` in order to store my API key as an environment variable. 
- Starting with the tests on line 94, I opted to use `assert_equal false, method_name(result)` instead of `refute method_name(result)` as I wanted the tests to pass only if the response was `false` instead of passing from either a `nil` or a `false` response.  
- For the last task(#7), I tested that the API could return all movies with the keyword `carson` that were released in 2020. There were more than I expected! I checked that the only type of results we were getting were `movies` from `2020` with the keyword `carson` in the title. 

***
## Acknowledgements:
Thank you for taking the time to review my code! Looking forward to walking through it soon :)

***
## Bonus Joke!
Did you hear about the new Peekaboo virus?
...
...
...
They reccommend that if you get it, you go straight to the **ICU**

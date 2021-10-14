# Curious about the weather? Welcome to Weather Wonderer

Detailed weather forecast including high, low, pressure, humidity for curious minds.

## Set up the environment

### Dependencies:

- Install Ruby with rbenv (`rbenv install $(cat .ruby-version)`) or rvm
- Install gems: `bundle`
- Install JS packages
- Get a OpenWeather API Key:

    - Sign up and get a free API key
    - You need to add this API key to your credentials. To do that, do below:
      - EDITOR=vim bin/rails credentials:edit
      - Add the below lines in the opened file(without the dot before each line)
      - open_weather:
         - api_key: API_KEY_FROM_OPEN_WEATHER

- To enable caching in development do: rails dev:cache

- There are 2 query services: ForecastQueryService and WeatherQueryService
- ForecastQueryService is for querying forecast results for the next 6 consecutive 3 hour intervals.
- ForecastQueryService results are cached for 30 minutes for all subsequent requests by zip codes.
- WeatherQueryService is for querying the current weather at the given time

## Tests:

- Running the integration tests: rspec spec/weather_spec.rb

## Troubleshooting:

If you have any questions, please email me at mesutcan121atgmaildotcom

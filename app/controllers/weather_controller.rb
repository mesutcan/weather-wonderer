class WeatherController < ApplicationController
  WEATHER_BASE_URL = "http://api.openweathermap.org/data/2.5/weather"
  FORECAST_BASE_URL = "http://api.openweathermap.org/data/2.5/forecast"

  # if geolocation is enabled in the browser, browser will use the current location.
  def index
    if params[:lat_long].present?
      @lat_long = params[:lat_long].split("|")
      @weather_output = WeatherQueryService.new(lat_long: @lat_long).call
      @forecast_output = ForecastQueryService.new(lat_long: @lat_long).call
    end
  end

  # search by zipcode, comes from the search box
  def zipcode
    if params[:zipcode].present?
      @weather_output =  WeatherQueryService.new(zipcode: params[:zipcode]).call
      @using_cached_forecast = Rails.cache.read("#{params[:zipcode]}").present?
      @forecast_output = ForecastQueryService.new(zipcode: params[:zipcode]).call
    end
  end
end

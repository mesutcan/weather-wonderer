class WeatherController < ApplicationController
  WEATHER_BASE_URL = "http://api.openweathermap.org/data/2.5/weather"
  FORECAST_BASE_URL = "http://api.openweathermap.org/data/2.5/forecast"

  # if geolocation is enabled in the browser, browser will use the current location.
  def index
    if params[:lat_long].present?
      @lat_lang = params[:lat_long].split("|")
      weather_url =
        "#{WEATHER_BASE_URL}?lat=#{@lat_lang[0]}&lon=#{@lat_lang[1]}&appid=#{Rails.application.credentials[:open_weather][:api_key]}&units=imperial"
      @weather_output = JSON.parse(Net::HTTP.get(URI(weather_url)))
      forecast_url = "#{FORECAST_BASE_URL}?lat=#{@lat_lang[0]}&lon=#{@lat_lang[1]}&cnt=6&appid=#{Rails.application.credentials[:open_weather][:api_key]}&units=imperial"
      @forecast_output = JSON.parse(Net::HTTP.get(URI(forecast_url)))
    end
  end

  # search by zipcode, comes from the search box
  def zipcode
    if params[:zipcode].present?
      weather_url =
        "#{WEATHER_BASE_URL}?zip=#{params[:zipcode]},us&appid=#{Rails.application.credentials[:open_weather][:api_key]}&units=imperial"
      @weather_output = JSON.parse(Net::HTTP.get(URI(weather_url)))
      # Cache the forecast results for 30 mins for the next 6 results(meaning 6 next consecutive 3 hour intervals)
      @using_cached_forecast = Rails.cache.read("#{params[:zipcode]}").present?
      @forecast_output ||= Rails.cache.fetch("#{params[:zipcode]}", expires_in: 30.minutes) do
        forecast_url = "#{FORECAST_BASE_URL}?zip=#{params[:zipcode]},us&cnt=6&appid=#{Rails.application.credentials[:open_weather][:api_key]}&units=imperial"
        JSON.parse(Net::HTTP.get(URI(forecast_url)))
      end
    end
  end
end

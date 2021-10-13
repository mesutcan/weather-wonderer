class WeatherController < ApplicationController
  WEATHER_URL = "http://api.openweathermap.org/data/2.5/weather"
  FORECAST_URL = "http://api.openweathermap.org/data/2.5/forecast"

  def index
    if params[:lat_long].present?
      @lat_lang = params[:lat_long].split("|")
      weather_url =
        "#{WEATHER_URL}?lat=#{@lat_lang[0]}&lon=#{@lat_lang[1]}&appid=#{Rails.application.credentials[:open_weather][:api_key]}&units=imperial"
      @weather_output = JSON.parse(Net::HTTP.get(URI(weather_url)))
      forecast_url = "#{FORECAST_URL}?lat=#{@lat_lang[0]}&lon=#{@lat_lang[1]}&cnt=6&appid=#{Rails.application.credentials[:open_weather][:api_key]}&units=imperial"
      @forecast_output = JSON.parse(Net::HTTP.get(URI(forecast_url)))
    end
  end

  def zipcode
    if params[:zipcode].present?
      weather_url =
        "#{WEATHER_URL}?zip=#{params[:zipcode]},us&appid=#{Rails.application.credentials[:open_weather][:api_key]}&units=imperial"
      @weather_output = JSON.parse(Net::HTTP.get(URI(weather_url)))
      forecast_url = "#{FORECAST_URL}?zip=#{params[:zipcode]},us&cnt=6&appid=#{Rails.application.credentials[:open_weather][:api_key]}&units=imperial"
      @forecast_output = JSON.parse(Net::HTTP.get(URI(forecast_url)))
    end
  end
end
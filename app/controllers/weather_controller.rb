class WeatherController < ApplicationController
  before_action :fetch_location_params, only: [:index, :zipcode]

  def index
    if @lat_long
      load_weather_and_forecast(lat_long: @lat_long)
    else
      flash[:alert] = "Geolocation data is missing."
      redirect_to root_path
    end
  end

  def zipcode
    if @zipcode
      load_weather_and_forecast(zipcode: @zipcode)
    else
      flash[:alert] = "Zipcode is required."
      redirect_to root_path
    end
  end

  private

  def fetch_location_params
    @lat_long = params[:lat_long]&.split("|") if params[:lat_long].present?
    @zipcode = params[:zipcode] if params[:zipcode].present?
  end

  def load_weather_and_forecast(options = {})
    @weather_output = WeatherQueryService.new(options).call
    @forecast_output = fetch_cached_forecast(options) || ForecastQueryService.new(options).call
  end

  def fetch_cached_forecast(options)
    if options[:zipcode]
      cache_key = options[:zipcode]
      Rails.cache.fetch(cache_key, expires_in: 1.hour) do
        ForecastQueryService.new(zipcode: cache_key).call
      end
    end
  end
end

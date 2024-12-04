class ForecastQueryService
  include Virtus.model

  FORECAST_BASE_URL = "http://api.openweathermap.org/data/2.5/forecast".freeze

  attribute :zipcode, String
  attribute :lat_long, Array

  def call
    if zipcode.present?
      fetch_and_cache_forecast(query_params: { zip: "#{zipcode},us" })
    elsif lat_long.present?
      fetch_forecast(query_params: { lat: lat_long[0], lon: lat_long[1] })
    else
      raise ArgumentError, "Either zipcode or lat_long must be provided."
    end
  end

  private

  def api_key
    Rails.application.credentials.dig(:open_weather, :api_key) || raise("API key not configured.")
  end

  def fetch_and_cache_forecast(query_params:)
    cache_key = query_params[:zip] || "#{query_params[:lat]}|#{query_params[:lon]}"
    Rails.cache.fetch(cache_key, expires_in: 30.minutes) do
      fetch_forecast(query_params: query_params)
    end
  end

  def fetch_forecast(query_params:)
    query_params[:appid] = api_key
    query_params[:units] = "imperial"
    query_params[:cnt] = 6 # Get the next 6 forecast intervals (3-hour blocks)

    response = Net::HTTP.get_response(uri_with_params(query_params))
    handle_response(response)
  end

  def uri_with_params(params)
    URI(FORECAST_BASE_URL).tap do |uri|
      uri.query = URI.encode_www_form(params)
    end
  end

  def handle_response(response)
    case response
    when Net::HTTPSuccess
      JSON.parse(response.body)
    else
      raise "Failed to fetch forecast data: #{response.message} (#{response.code})"
    end
  end
end

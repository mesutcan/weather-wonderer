class WeatherQueryService
  include Virtus.model

  CURRENT_WEATHER_BASE_URL = "http://api.openweathermap.org/data/2.5/weather".freeze

  attribute :zipcode, String
  attribute :lat_long, Array

  def call
    if zipcode.present?
      fetch_weather(query_params: { zip: "#{zipcode},us" })
    elsif lat_long.present?
      fetch_weather(query_params: { lat: lat_long[0], lon: lat_long[1] })
    else
      raise ArgumentError, "Either zipcode or lat_long must be provided."
    end
  end

  private

  def api_key
    Rails.application.credentials.dig(:open_weather, :api_key) || raise("API key not configured.")
  end

  def fetch_weather(query_params:)
    query_params[:appid] = api_key
    query_params[:units] = "imperial"

    response = Net::HTTP.get_response(uri_with_params(query_params))
    handle_response(response)
  end

  def uri_with_params(params)
    URI(CURRENT_WEATHER_BASE_URL).tap do |uri|
      uri.query = URI.encode_www_form(params)
    end
  end

  def handle_response(response)
    case response
    when Net::HTTPSuccess
      JSON.parse(response.body)
    else
      raise "Failed to fetch weather data: #{response.message} (#{response.code})"
    end
  end
end

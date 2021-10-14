class ForecastQueryService
  include Virtus.model
  FORECAST_BASE_URL = "http://api.openweathermap.org/data/2.5/forecast"

  attribute :zipcode
  attribute :lat_long

  def call
    @call = zipcode.present? ? forecast_by_zipcode : forecast_by_lat_long
  end

  private

  def api_key
    Rails.application.credentials[:open_weather][:api_key]
  end

  # Cache the forecast results for 30 mins for the next 6 results(meaning 6 next consecutive 3 hour intervals)
  def forecast_by_zipcode
    Rails.cache.fetch(zipcode, expires_in: 30.minutes) do
      forecast_url = "#{FORECAST_BASE_URL}?zip=#{zipcode},us&cnt=6&appid=#{api_key}&units=imperial"
      JSON.parse(Net::HTTP.get(URI(forecast_url)))
    end
  end

  def forecast_by_lat_long
    forecast_url = "#{FORECAST_BASE_URL}?lat=#{lat_long[0]}&lon=#{lat_long[1]}&cnt=6&appid=#{api_key}&units=imperial"
    JSON.parse(Net::HTTP.get(URI(forecast_url)))
  end
end
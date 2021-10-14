class WeatherQueryService
  include Virtus.model
  WEATHER_BASE_URL = "http://api.openweathermap.org/data/2.5/weather"

  attribute :zipcode
  attribute :lat_long

  def call
    @call = zipcode.present? ? weather_by_zipcode : weather_by_lat_long
  end

  private

  def api_key
    Rails.application.credentials[:open_weather][:api_key]
  end

  def weather_by_zipcode
    weather_url = "#{WEATHER_BASE_URL}?zip=#{zipcode},us&appid=#{api_key}&units=imperial"
    JSON.parse(Net::HTTP.get(URI(weather_url)))
  end

  def weather_by_lat_long
    weather_url = "#{WEATHER_BASE_URL}?lat=#{lat_long[0]}&lon=#{lat_long[1]}&appid=#{api_key}&units=imperial"
    JSON.parse(Net::HTTP.get(URI(weather_url)))
  end
end
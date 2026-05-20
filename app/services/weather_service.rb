# Use the Open Meteo API to get the weather for a given address.
class WeatherService
  BASE_URL = "https://api.open-meteo.com/v1/forecast"

  def self.get_weather(address)
    # The API requires the latitude & longitude, so get that from the address
    coordinates = LocationService.get_location_data(address)
    cache_key = "weather_data_#{coordinates[:zip_code]}"

    # Return weather from cache, if it exists. Mark as cached.
    if Rails.cache.exist?(cache_key)
      Rails.logger.debug("WeatherService #{cache_key} found in cache")
      cached_weather = Rails.cache.read(cache_key)
      cached_weather["cached"] = true
      return cached_weather
    end

    get_weather_from_api(coordinates[:latitude], coordinates[:longitude], cache_key)
  end

  private

  def self.get_weather_from_api(latitude, longitude, cache_key)
    response = connection.get do |req|
      req.params[:latitude] = latitude
      req.params[:longitude] = longitude
    end

    weather = JSON.parse(response.body)

    Rails.logger.debug("WeatherService weather: #{weather}")
    # Only cache for 30 minutes to ensure weather is up to date.
    Rails.cache.write(cache_key, weather, expires_in: 30.minutes)
    weather["cached"] = false

    weather
  end

  def self.connection
    conn = Faraday.new(
      url: BASE_URL,
      headers: {
        "Content-Type" => "application/json"
      },
      params: {
        current_weather: true,
        temperature_unit: "fahrenheit",
        # hourly: "temperature_2m",
        daily: "temperature_2m_max,temperature_2m_min"
      }
    )
    conn
  end
end

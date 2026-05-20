# Use the Census Geocoding API to get the latitude & longitude for a given address.
class LocationService
  BASE_URL = "https://geocoding.geo.census.gov/geocoder/locations/onelineaddress"

  def self.get_location_data(address)
    # Check if zip code has been cached.
    if address[:zip_code].present? and Rails.cache.exist?("location_data_#{address[:zip_code]}")
      Rails.logger.debug("LocationService location_data_#{address[:zip_code]} found in cache")
      return Rails.cache.read("location_data_#{address[:zip_code]}")
    end

    location = get_location_data_from_api(address)
    Rails.logger.debug("LocationService location: #{location}")
    x_y_coordinates = location["result"]["addressMatches"][0]["coordinates"]

    location_data = {
      latitude: x_y_coordinates["y"],
      longitude: x_y_coordinates["x"],
      zip_code: location["result"]["addressMatches"][0]["addressComponents"]["zip"]
    }

    # Write location data to cache. Since zip codes aren't expected to change,
    # keep it in cache for a year.
    Rails.cache.write("location_data_#{address[:zip_code]}", location_data, expires_in: 1.year)

    location_data
  end

  private

  def self.get_location_data_from_api(address)
    address_string = format_address(address)
    Rails.logger.debug("LocationService address_string: #{address_string}")

    response = connection.get do |req|
      req.params[:address] = address_string
    end

    address_data = JSON.parse(response.body)

    # Check if an address exists in the result
    if address_data["result"]["addressMatches"].empty?
      Rails.logger.error("LocationService address_data: #{address_data}")
      raise ActionController::RoutingError.new("Address Not Found")
    end

    address_data
  end

  def self.format_address(address)
    address_string = ""
    address_string += address[:street_number].strip + " " if address[:street_number].present?
    address_string += address[:street_name].strip + ", " if address[:street_name].present?
    address_string += address[:city].strip + ", " if address[:city].present?
    address_string += address[:state].strip + " " if address[:state].present?
    address_string += address[:zip_code].strip if address[:zip_code].present?
    address_string.strip.gsub(" ", "+")
  end

  def self.connection
    conn = Faraday.new(
      url: BASE_URL,
      headers: {
        "Content-Type" => "application/json"
      },
      params: {
        benchmark: "Public_AR_Current",
        format: "json"
      }
    )
    conn
  end
end

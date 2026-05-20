require 'rails_helper'

RSpec.describe "Api::WeatherController", type: :request do
  include_context "api response data"
  include_context "addresses"

  before do
    allow(LocationService).to receive(:get_location_data_from_api).with(address).and_return(location_api_response)

    allow(LocationService).to receive(:get_location_data_from_api).with(address_2).and_raise(
      ActionController::RoutingError.new("Address Not Found")
    )

    allow(WeatherService).to receive(:get_weather_from_api).and_return(weather_api_response)
  end

  describe "GET /index" do
    it 'returns the weather for a given address' do
      get api_weather_index_path, params: address
      expect(response).to have_http_status(:success)
      expect(response.body).to include("Daily Forecast")
    end

    it 'raises an error if the address is not found' do
      get api_weather_index_path, params: address_2
      expect(response.body).to include("Address not found")
    end
  end
end

require 'rails_helper'

RSpec.describe WeatherService, type: :service do
  include_context "addresses"
  include_context "api response data"

  before do
    allow(LocationService).to receive(:get_location_data_from_api).with(address).and_return(location_api_response)
    allow(WeatherService).to receive(:get_weather_from_api).and_return(weather_api_response)
    allow(LocationService).to receive(:get_location_data_from_api).with(address_2).and_raise(
      ActionController::RoutingError.new("Address Not Found")
    )
  end

  describe '#get_weather' do
    it 'returns the weather for a given address' do
      weather = WeatherService.get_weather({ street_number: '123', street_name: 'Main St', city: 'Anytown', state: 'CA', zip_code: '12345' })
      expect(weather["current_weather"]).to_not be_nil
      expect(weather["daily"]).to_not be_nil
    end

    it 'raises an error if the address is not found' do
      expect { WeatherService.get_weather(address_2) }.to raise_error(ActionController::RoutingError)
    end
  end
end

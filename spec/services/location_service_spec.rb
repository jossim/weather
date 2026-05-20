require 'rails_helper'

RSpec.describe LocationService, type: :service do
  describe '#get_location_data' do
    include_context "addresses"
    include_context "api response data"

    before do
      allow(LocationService).to receive(:get_location_data_from_api).with(address).and_return(location_api_response)

      allow(LocationService).to receive(:get_location_data_from_api).with(address_2).and_raise(
        ActionController::RoutingError.new("Address Not Found")
      )
    end

    it 'returns location data for a given address' do
      location = LocationService.get_location_data(address)
      expect(location[:latitude]).to eq(37.647403995334)
      expect(location[:longitude]).to eq(-94.647403995334)
      expect(location[:zip_code]).to eq("12345")
    end

    it 'raises an error if the address is not found' do
      expect { LocationService.get_location_data(address_2) }.to raise_error(ActionController::RoutingError)
    end
  end
end

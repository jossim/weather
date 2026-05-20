require 'rails_helper'

RSpec.describe LocationService, type: :service do
  describe '#get_location_data' do
    let(:address) { {
      street_number: '123', street_name: 'Main St', city: 'Anytown', state: 'CA', zip_code: '12345' 
    } }

    let(:address_2) { {
      street_number: '456', street_name: 'Main St', city: 'Notown', state: 'TX', zip_code: '67890'
    } }
    before do
      allow(LocationService).to receive(:get_location_data_from_api).with(address).and_return({
        "result" => {
          "input" => {
            "address" => { "address" => "123+Main+St,+Anytown,+CA+12345" },
            "benchmark" => { "isDefault" => true, "benchmarkDescription" => "Public Address Ranges - Current Benchmark", "id" => "4", "benchmarkName" => "Public_AR_Current"}
          },
          "addressMatches" => [
            {
              "tigerLine" => { "side" => "R", "tigerLineId" => "63966885"},
              "coordinates" => { "x" => -94.647403995334, "y" => 37.647403995334 },
              "addressComponents" => { 
                "zip" => "12345", 
                "streetName" => "Main St", "preType" => "",
                "city" => "Anytown", 
                "preDirection" => "", 
                "suffixDirection" => "", 
                "fromAddress" => "123", 
                "state" => "CA", 
                "suffixType" => "DR", 
                "toAddress" => "123", 
                "suffixQualifier" => "", 
                "preQualifier" => ""
              },
              "matchedAddress" => "123 Main St, Anytown, CA, 12345" 
            }
          ]
        }
      })

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

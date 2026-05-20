RSpec.shared_context "addresses" do
  let(:address) { { street_number: '123', street_name: 'Main St', city: 'Anytown', state: 'CA', zip_code: '12345' } }
  let(:address_2) { { street_number: '456', street_name: 'Main St', city: 'Notown', state: 'TX', zip_code: '67890' } }
end

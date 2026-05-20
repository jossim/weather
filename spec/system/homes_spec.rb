require 'rails_helper'

RSpec.describe "Home", type: :system, js: true do
  include_context "addresses"
  include_context "api response data"

  before do
    driven_by(:selenium_chrome_headless)
    allow(LocationService).to receive(:get_location_data_from_api).with(address).and_return(location_api_response)

    allow(LocationService).to receive(:get_location_data_from_api).with(address_2).and_raise(
      ActionController::RoutingError.new("Address Not Found")
    )

    allow(WeatherService).to receive(:get_weather_from_api).and_return(weather_api_response)
  end

  it "displays the weather for a given address" do
    visit root_path
    fill_in "Street Number", with: "123"
    fill_in "Street Name", with: "Main St"
    fill_in "City", with: "Anytown"
    fill_in "State", with: "CA"
    fill_in "Zip Code", with: "12345"
    click_button "Get Weather"
    expect(page).to have_content("Daily Forecast")
  end

  it "displays an error message if the address is not found" do
    visit root_path
    fill_in "Street Number", with: "456"
    fill_in "Street Name", with: "Main St"
    fill_in "City", with: "Notown"
    fill_in "State", with: "TX"
    fill_in "Zip Code", with: "67890"
    click_button "Get Weather"
    expect(page).to have_content("Address not found")
  end
end

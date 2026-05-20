require 'rails_helper'

RSpec.describe "Homes", type: :system, js: true do
  let(:address) { { street_number: '123', street_name: 'Main St', city: 'Anytown', state: 'CA', zip_code: '12345' } }
  let(:address_2) { { street_number: '456', street_name: 'Main St', city: 'Notown', state: 'TX', zip_code: '67890' } }


  before do
    driven_by(:selenium_chrome_headless)
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

    allow(WeatherService).to receive(:get_weather_from_api).and_return({
      "latitude" => 37.66092, 
      "longitude" => -94.647403995334, 
      "generationtime_ms" => 0.1666545867919922, 
      "utc_offset_seconds" => 0, 
      "timezone" => "GMT", 
      "timezone_abbreviation" => "GMT", 
      "elevation" => 205.0, 
      "current_weather_units" => {
        "time" => "iso8601", 
        "interval" => "seconds", 
        "temperature" => "°F", 
        "windspeed" => "km/h", 
        "winddirection" => "°", 
        "is_day" => "", 
        "weathercode" => "wmo code"
      }, 
      "current_weather" => {
        "time" => "2026-05-20T17:00", 
        "interval" => 900, 
        "temperature" => 72.6, 
        "windspeed" => 6.1, 
        "winddirection" => 357, 
        "is_day" => 1, 
        "weathercode" => 3
      }, 
      "daily_units" => {
        "time" => "iso8601", 
        "temperature_2m_max" => "°F", 
        "temperature_2m_min" => "°F"
      },
      "daily" => {
        "time" => ["2026-05-20", "2026-05-21", "2026-05-22", "2026-05-23", "2026-05-24", "2026-05-25", "2026-05-26"],
        "temperature_2m_max" => [86.8, 80.3, 88.5, 85.2, 83.2, 87.8, 88.6],
        "temperature_2m_min" => [66.9, 69.8, 69.4, 71.5, 66.1, 68.1, 69.5]
      }
    })
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

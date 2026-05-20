require 'rails_helper'

RSpec.describe Weather, type: :model do
  include_context "api response data"

  let!(:weather) { Weather.new(weather_api_response) }

  it 'initializes with weather data' do
    expect(weather.current_temperature).to eq(weather_api_response["current_weather"]["temperature"])
  end

  it 'returns the current temperature' do
    expect(weather.current_temperature).to eq(weather_api_response["current_weather"]["temperature"])
  end

  it 'formats the daily forecast' do
    expect(weather.daily_forecast).to eq([
      { time: "2026-05-20", high_temperature: 86.8, low_temperature: 66.9 },
      { time: "2026-05-21", high_temperature: 80.3, low_temperature: 69.8 },
      { time: "2026-05-22", high_temperature: 88.5, low_temperature: 69.4 },
      { time: "2026-05-23", high_temperature: 85.2, low_temperature: 71.5 },
      { time: "2026-05-24", high_temperature: 83.2, low_temperature: 66.1 },
      { time: "2026-05-25", high_temperature: 87.8, low_temperature: 68.1 },
      { time: "2026-05-26", high_temperature: 88.6, low_temperature: 69.5 }
    ])
  end
end

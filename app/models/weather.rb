class Weather
  attr_reader :cached

  def initialize(weather_params)
    @current_weather = weather_params["current_weather"]
    @daily_weather = weather_params["daily"]
    @cached = weather_params["cached"]
  end

  def current_temperature
    @current_weather["temperature"]
  end

  def current_high_temperature
    @daily_weather["temperature_2m_max"][0]
  end

  def current_low_temperature
    @daily_weather["temperature_2m_min"][0]
  end

  def daily_forecast
    @daily_weather["time"].map.with_index do |time, index|
      {
        time: time,
        high_temperature: @daily_weather["temperature_2m_max"][index],
        low_temperature: @daily_weather["temperature_2m_min"][index]
      }
    end
  end
end

# {"latitude" => 30.429369,
#  "longitude" => -97.78488,
#  "generationtime_ms" => 0.19598007202148438,
#  "utc_offset_seconds" => 0,
#  "timezone" => "GMT",
#  "timezone_abbreviation" => "GMT",
#  "elevation" => 286.0,
#  "current_weather_units" =>
#   {"time" => "iso8601",
#    "interval" => "seconds",
#    "temperature" => "°F",
#    "windspeed" => "km/h",
#    "winddirection" => "°",
#    "is_day" => "",
#    "weathercode" => "wmo code"},
#  "current_weather" =>
#   {"time" => "2026-05-19T23:00",
#    "interval" => 900,
#    "temperature" => 89.4,
#    "windspeed" => 18.5,
#    "winddirection" => 147,
#    "is_day" => 1,
#    "weathercode" => 3},
#  "daily_units" => {"time" => "iso8601", "temperature_2m_max" => "°F", "temperature_2m_min" => "°F"},
#  "daily" =>
#   {"time" => ["2026-05-19", "2026-05-20", "2026-05-21", "2026-05-22", "2026-05-23", "2026-05-24", "2026-05-25"],
#    "temperature_2m_max" => [91.1, 86.8, 84.0, 90.3, 86.1, 80.2, 87.0],
#    "temperature_2m_min" => [75.4, 66.9, 67.5, 70.8, 68.3, 66.9, 67.0]},
#  "cached" => true}


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

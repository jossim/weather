class Api::WeatherController < ActionController::API
  rescue_from ActionController::RoutingError, with: :address_not_found

  def index
    weather_data = WeatherService.get_weather(weather_params.to_h)
    weather = Weather.new(weather_data)
    render partial: "forecast", locals: { weather: weather }
  end

  private

  def weather_params
    params.permit(
      :street_number, :street_name, :city, :state, :zip_code
    )
  end

  def address_not_found
    html = "<h1 class='text-2xl font-bold mt-4'>Address not found</h1><p>Please double check or try again with a valid address.</p>".html_safe

    render html: html
  end
end

import { Controller } from "@hotwired/stimulus"

export default class WeatherController extends Controller {
	static targets = [ "forecast" ];

  connect() {
    console.log("WeatherController connected")
  }

  async submit(event) {
		const formData = new FormData(event.target);
		const params = new URLSearchParams(formData);
		const url = `/api/weather?${params.toString()}`;

    event.preventDefault()
    console.log("WeatherController submit")

		try {
			const response = await fetch(url, {
				method: "GET",
			});

			const text = await response.text();
			this.forecastTarget.innerHTML = text;
		} catch (error) {
			console.error(error);
		}
	}
}

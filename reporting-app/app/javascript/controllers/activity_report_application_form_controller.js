import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="hours-to-minutes"
export default class extends Controller {
  static targets = ["hoursField"]

  connect() {
    // Set up event listener for form submission
    const form = this.element.closest('form')
    if (form) {
      form.addEventListener('submit', this.convertHoursToMinutes.bind(this))
    }
  }

  convertHoursToMinutes(event) {
    const hoursField = this.element.querySelector('[data-hours-to-minutes]')
    if (hoursField && hoursField.value) {
      const hours = parseFloat(hoursField.value)
      const minutes = Math.round(hours * 60)
      hoursField.value = minutes
    } else {
      hoursField.value = 0
    }
  }
}

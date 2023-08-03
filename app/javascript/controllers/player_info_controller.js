import { Controller } from "@hotwired/stimulus"

export default class extends Controller {

  static values = {
    url: String,
    peaks: String,
    id: Number
  }

  connect() {
    console.log("player info controller")
    const eventData = {
      url: this.urlValue,
      peaks: this.peaksValue,
      id: this.idValue
    }
    const event = new CustomEvent("player:info", { detail: eventData })
    document.dispatchEvent(event)
  }
}

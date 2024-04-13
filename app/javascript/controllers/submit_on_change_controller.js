import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  handleChange(event) {
    this.element.requestSubmit();
  }
}
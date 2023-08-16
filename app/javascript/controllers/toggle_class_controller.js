import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  toggle(event) {
    // Toggle 'active' class on button
    event.currentTarget.classList.toggle('active');
    
    // Toggle 'hidden' class on controller's root element
    this.element.classList.toggle('hidden');
  }
}
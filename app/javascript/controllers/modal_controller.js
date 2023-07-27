import { Controller } from '@hotwired/stimulus';

export default class extends Controller {
  connect() {
    this.element.style.display = 'block';
  }

  close(event) {
    //if (event.currentTarget.classList.contains('fixed')) {
      this.element.style.display = 'none';
    //}
  }
}

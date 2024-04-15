import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    this.observer = new MutationObserver(mutations => {
      mutations.forEach(mutation => {
        if (mutation.type === "attributes" && mutation.attributeName === "value") {
          this.submitForm();
        }
      });
    });

    this.observe();
  }

  observe() {
    this.observer.observe(this.element, {
      attributes: true 
    });
  }

  submitForm() {
    this.element.form.requestSubmit();
  }

  disconnect() {
    this.observer.disconnect();
  }
}
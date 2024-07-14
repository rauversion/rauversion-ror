import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  connect() {
    console.log("SubmitOnChangeController connected");
  }

  submitForm(event) {
    // Prevent the default behavior if needed
    // event.preventDefault();

    let hiddenInput = document.createElement("input");
    hiddenInput.type = "hidden";
    hiddenInput.name = "changed_form";
    hiddenInput.value = "true";
    this.element.appendChild(hiddenInput);

    // Submit the form
    this.element.requestSubmit();
  }
}
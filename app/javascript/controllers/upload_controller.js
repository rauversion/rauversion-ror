// app/javascript/controllers/upload_controller.js

import { Controller } from "@hotwired/stimulus";
import { DirectUpload } from "@rails/activestorage";

export default class extends Controller {
  static targets = ["input", "progress"];

  uploadFile() {
    Array.from(this.inputTarget.files).forEach((file) => {
      const upload = new DirectUpload(
        file,
        this.inputTarget.dataset.directUploadUrl,
        this // callback directUploadWillStoreFileWithXHR(request)
      );
      upload.create((error, blob) => {
        if (error) {
          console.log(error);
        } else {
          this.createHiddenBlobInput(blob);
          // if you're not submitting the form after upload, you need to attach
          // uploaded blob to some model here and skip hidden input.
        }
      });
    });
  }

  // add blob id to be submitted with the form
  createHiddenBlobInput(blob) {
    const hiddenField = document.createElement("input");
    hiddenField.setAttribute("type", "hidden");
    hiddenField.setAttribute("value", blob.signed_id);
    hiddenField.name = this.inputTarget.name;
    this.element.appendChild(hiddenField);
  }

  directUploadWillStoreFileWithXHR(request) {
    request.upload.addEventListener("progress", (event) => {
      this.progressUpdate(event);
    });
  }

  progressUpdate(event) {
    const progress = (event.loaded / event.total) * 100;
    this.progressTarget.innerHTML = progress;

    // if you navigate away from the form, progress can still be displayed 
    // with something like this:
    // document.querySelector("#global-progress").innerHTML = progress;
  }
}
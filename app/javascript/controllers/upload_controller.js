import { Controller } from "@hotwired/stimulus";
import { DirectUpload } from "@rails/activestorage";

export default class extends Controller {
  //static targets = ["input", "progress"];
  static targets = ["input", "progressContainer", "template", "submit"]; // Renaming target to "progressContainer"

  connect(){
    // this.el = this.element;
    // this.inputTarget.addEventListener('change', () => {
    //   this.uploadFile();
    // });
  }

  uploadFile() {
    this.totalUploads = this.inputTarget.files.length;  // Set the total number of files to be uploaded
    this.completedUploads = 0;  // Counter for completed uploads

    Array.from(this.inputTarget.files).forEach((file, index) => {
      const identifier = Math.floor(Math.random() * Date.now()).toString(16)
      const progressBar = this.add_template(identifier, file) //this.createProgressBar(identifier);

      const upload = new DirectUpload(
        file,
        this.inputTarget.dataset.directUploadUrl,
        {
          directUploadWillStoreFileWithXHR: (request)=>{
            console.log(progressBar)
            
            request.upload.addEventListener("progress", (event) => {
              this.progressUpdate(event, identifier);
            });
          }
        }
      );

      upload.create((error, blob) => {
        if (error) {
          console.log(error);
        } else {
          this.createHiddenBlobInput(blob);
          // if you're not submitting the form after upload, you need to attach
          // uploaded blob to some model here and skip hidden input.

          this.completedUploads++;
          // Check if all uploads are complete
          this.checkAllUploadsComplete();
        }
      });
    });
  }

  checkAllUploadsComplete() {
    if (this.completedUploads === this.totalUploads) {
      console.log("All uploads are complete!");
      this.submitTarget.classList.toggle("hidden")
      // Here you can perform any other actions you want when all files are uploaded
    }
  }

  createProgressBar(index) {
    const progressBar = document.createElement('div');
    progressBar.setAttribute("id", `progress-bar-${index}`);
    progressBar.style.width = "0%";
    progressBar.style.height = "20px";
    progressBar.style.backgroundColor = "green";
    progressBar.style.marginTop = "10px";

    this.progressContainerTarget.appendChild(progressBar); // Append to the container

    return progressBar;
  }

  // add blob id to be submitted with the form
  createHiddenBlobInput(blob) {
    const hiddenField = document.createElement("input");
    hiddenField.setAttribute("type", "hidden");
    hiddenField.setAttribute("value", blob.signed_id);
    hiddenField.name = this.inputTarget.name;
    this.element.appendChild(hiddenField);
  }

  add_template(identifier, file) {
    let doc = this.templateTarget
    var content = doc.innerHTML.replace(/NEW_RECORD/g, `progress-bar-${identifier}`);
    content = content.replace(/FILE/g, `${file.name}`);
    this.progressContainerTarget.insertAdjacentHTML('beforebegin', content);
  }

  progressUpdate(event, index) {
    const progress = (event.loaded / event.total) * 100;
    const fileIndex = index

    const progressBar = document.querySelector(`#progress-bar-${fileIndex}`);
    if (progressBar) {
      progressBar.style.width = `${progress}%`;
    }
  }

  preventDefaults(e) {
    e.preventDefault();
    e.stopPropagation();
  }

  // When a file is dropped onto the designated area
  handleDrop(e) {
    this.preventDefaults(e);
    let files = e.dataTransfer.files;
    this.inputTarget.files = files;
    this.uploadFile();
  }
}
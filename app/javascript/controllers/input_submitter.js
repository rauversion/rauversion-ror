import { Controller } from "@hotwired/stimulus"
import { get, post, put, patch, destroy } from '@rails/request.js'


export default class extends Controller {
  //static targets = [ "checkbox", "radio", "form" ]

  connect() {
    //this.checkboxTarget.addEventListener('change', () => this.submitForm())
    //this.radioTarget.addEventListener('change', () => this.submitForm())
  }

  async submitForm() {
    let formData = new FormData(this.element)
    formData.append('nonpersist', true)

    //await fetch(this.formTarget.action, {
    //  method: this.formTarget.method,
    //  body: formData
    //})

    const response = await post(this.element.action, { 
      responseKind: "turbo-stream", 
      body: formData
    })

    
    if (response.redirected) {
      Turbo.visit(response.response.url);
    }
  }
}
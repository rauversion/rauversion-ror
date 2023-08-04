import { Controller } from "@hotwired/stimulus"
import { get, post, put, patch, destroy } from '@rails/request.js'

export default class extends Controller {
  static targets = ["button"]
  static values = {
    url: String
  }

  connect() {
   
  }

  play(e){
    e.preventDefault()
    console.log("PLAY", this.urlValue)
    this.updateArticle(this.urlValue)
  }

  async updateArticle (url) {
    const response = await get(url, { 
      responseKind: "turbo-stream", 
      //body: {
      //  post: { body: body, id: id }
      //} 
    })
    console.log("RESPONSE", response)
    //if (response.redirected) {
    //  Turbo.visit(response.response.url);
    //}
  }

}

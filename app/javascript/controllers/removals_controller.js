import { Controller } from "@hotwired/stimulus"

import { enter, leave } from "../el-transition";

export default class extends Controller {
  //static targets = ["container", "backdrop", "panel", "closeButton"];

  connect (){
    enter(this.element);
  }
  show() {
    //this.containerTarget.classList.remove("hidden");
    enter(this.element);
  }

  hide() {
    Promise.all([
      leave(this.element),
    ]).then(() => {
      //this.containerTarget.classList.add("hidden");
      this.element.remove()
    });
  }
}

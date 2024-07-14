import { Controller } from '@hotwired/stimulus';

export default class extends Controller {
  static targets = ["panel", "iconOpen", "iconClose"]

  connect(){
    this.handleIconDisplay()
  }
  
  toggle(event) {

    const el = event.currentTarget.closest('[data-accordeon]');
    const panelE = el.querySelector('[data-accordeon-target="panel"]');

    this.panelTargets.forEach((panel) => {
      
      if (panel === panelE) {
        panel.classList.toggle("hidden");
      } else {
        panel.classList.remove("open");
        panel.classList.remove("hidden");
      }
    });

    this.handleIconDisplay()
  }

  handleIconDisplay(){
    if( this.panelTarget.classList.contains("hidden")){
      if(this.hasIconOpenTarget){ this.iconOpenTarget.classList.add("hidden") }
      if(this.hasIconCloseTarget){ this.iconCloseTarget.classList.remove("hidden") }
    } else {
      if(this.hasIconOpenTarget){ this.iconOpenTarget.classList.remove("hidden") }
      if(this.hasIconCloseTarget){ this.iconCloseTarget.classList.add("hidden") }
    }
  }
}
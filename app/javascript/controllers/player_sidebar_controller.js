// sidebar-controller.js
import { Controller } from "@hotwired/stimulus";
import { get, put } from "@rails/request.js";

export default class extends Controller {
  static targets = ["container"];

  connect() {
    this.loadTracks();
  }

  async loadTracks() {
    const { playlist } = window.store.getState();

    const track_ids = playlist;  // Assuming `store` is globally accessible
    if (track_ids && track_ids.length) {
      const response = await put('/player', { 
        responseKind: "turbo-stream", 
        body: { player: {ids: track_ids } } 
      })
    }
  }
}
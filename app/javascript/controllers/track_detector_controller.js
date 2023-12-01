import { Controller } from "@hotwired/stimulus"

// it locates and append tracks to the playlist sidebar
export default class extends Controller {
  static targets = ["track"]

  connect() {
    this.detect()
  }

  detect(){
    console.log("TRACK DETECTOR", this.trackTargets)
    const newIds = this.trackTargets.map((track) => track.dataset.trackId)
    const playlist = new Set([...store.getState().playlist, ...newIds])
    store.setState({ playlist: Array.from(playlist) })
  }
}
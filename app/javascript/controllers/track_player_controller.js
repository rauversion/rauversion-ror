import { Controller } from "@hotwired/stimulus"
import WaveSurfer from 'wavesurfer.js'

export default class extends Controller {
  static targets = ["player", "playicon", "pauseicon", "play"]
  static values = {
    url: String,
    peaks: String,
    height: Number,
    id: Number
  }

  connect() {
    this.playiconTarget.style.display = 'none'
    this.pauseiconTarget.style.display = 'block'
    this.playing = false

    this.url = this.urlValue
    this.peaks = JSON.parse(this.peaksValue)
    this.height = this.heightValue
    this._wave = null

    this.initWave()

    this.element.addEventListener("click", this.playBtnListener.bind(this))
    window.addEventListener(`add-from-playlist`, this.addFromPlaylistListener.bind(this))
    
    console.log(`track player: audio-process-${this.idValue}`)

    document.addEventListener(`audio-process-${this.idValue}`, this.audioProcessListeners.bind(this))
    document.addEventListener(`audio-process-${this.idValue}-play`, this.audioProcessPlayListeners.bind(this))
    document.addEventListener(`audio-process-${this.idValue}-pause`, this.audioProcessPauseListeners.bind(this))
  }

  disconnect() {
    this.element.removeEventListener("click", this.playBtnListener)
    this._wave?.drawer?.wrapper?.removeEventListener('click', this.drawerListener)
    window.removeEventListener(`add-from-playlist`, this.addFromPlaylistListener)
    document.removeEventListener(`audio-process-${this.idValue}`, this.audioProcessListeners)
    document.removeEventListener(`audio-process-${this.idValue}-play`, this.audioProcessPlayListeners)
    document.removeEventListener(`audio-process-${this.idValue}-pause`, this.audioProcessPauseListeners)
    
    this.destroyWave()
  }

  initWave() {
    this._wave = WaveSurfer.create({
      container: this.element,
      backend: 'MediaElement',
      waveColor: 'grey',
      progressColor: 'white',
      height: this.height || 45,
      barWidth: 2,
      barGap: 3,
      pixelRatio: 10,
      cursorWidth: 1,
      cursorColor: "lightgray",
      responsive: true,
    })

    this._wave.load(this.url, this.peaks)

    this._wave.on('ready', () => {
      this._wave.getWrapper().addEventListener('click', this.drawerListener.bind(this))
    })
  }

  playBtnListener(e) {
    if(!this.playing){
      let event = new CustomEvent("play-song", {
        detail: {
          id: this.idValue
        }
      })
      this.element.dispatchEvent(event)
    } else {
      this.dispatchPause()
    }
  }

  play(e){
    
  }

  addFromPlaylistListener(e) {
    let event = new CustomEvent("play-song", {
      detail: {
        id: e.detail.track_id
      }
    })
    this.element.dispatchEvent(event)
  }

  audioProcessListeners(e) {
    this._wave.seekTo(e.detail.percent)
  }

  audioProcessPlayListeners(e) {
    this.playiconTarget.style.display = 'block'
    this.pauseiconTarget.style.display = 'none'
    this.playing = true
    this._wave.seekTo(e.detail.percent)
  }

  audioProcessPauseListeners(e) {
    this.playiconTarget.style.display = 'none'
    this.pauseiconTarget.style.display = 'block'
    this.playing = false
    this._wave.seekTo(e.detail.percent)
  }

  drawerListener(e) {
    setTimeout(() => {
      const trackId = this.idValue
      const ev = new CustomEvent(`audio-process-mouseup`, {
        detail: {
          trackId: trackId,
          position: this._wave.getCurrentTime(),
          percent: this._wave.getCurrentTime() / this._wave.getDuration()
        }
      })
      document.dispatchEvent(ev)
    }, 20)
  }

  destroyWave() {
    this._wave?.destroy()
  }

  dispatchPause() {
    const trackId = this.idValue
    const ev = new CustomEvent(`audio-pause`, {
      detail: {
        trackId: trackId
      }
    })
    document.dispatchEvent(ev)
  }
}

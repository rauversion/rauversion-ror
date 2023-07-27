import { Controller } from "@hotwired/stimulus";
import WaveSurfer from 'wavesurfer.js';

export default class extends Controller {
  static targets = ["player", "playicon", "pauseicon", "loadingicon", "play", "next", "rew", "range"];
  static values = {
    url: String,
    peaks: String,
    height: Number
  }
  initialize() {
    this.waveClickListener = null;
    this.hasHalfwayEventFired = false;

    this.currentSongIndex = 0;
    this.currentSong = window.store.getState().playlist[this.currentSongIndex];

    this.peaks = this.data.get("playerPeaks");
    this.url = this.data.get("playerUrl");

    this.rangeValue = window.store.getState().volume;

    /*
    this.element.addEventListener("click", (e) => {
      if (e.target.dataset.action === "play") {
        this.play(e);
      } else if (e.target.dataset.action === "next") {
        this.nextSong(e);
      } else if (e.target.dataset.action === "rew") {
        this.prevSong(e);
      }
    });*/

    /*this.rangeTarget.addEventListener("change", (e) => {
      window.store.setState({ volume: e.target.value });
      this._wave.setVolume(e.target.value);
      this.rangePaint(e.target);
    });*/

    //document.getElementById("toggle-volume").addEventListener("click", (e) => {
    //  document.getElementById("volume-wrapper").classList.toggle("hidden");
    //});

    window.addEventListener(`phx:add-to-next`, this.addToNextListener);
    window.addEventListener(`phx:play-song`, this.playSongListener);

    this.rangePaint(this.rangeTarget);

    this._wave = null;
    this.initWave();
  }

  disconnect() {
    this.element.removeEventListener("click");
    this.rangeTarget.removeEventListener("change");
    window.removeEventListener(`phx:add-to-next`, this.addToNextListener);
    window.removeEventListener(`phx:play-song`, this.playSongListener);
    this._wave.destroy();
  }

  toggleVolume(e){
    document.getElementById("volume-wrapper").classList.toggle("hidden");
  }

  updateVolume(e){
    window.store.setState({ volume: e.target.value });
    this._wave.setVolume(e.target.value);
    this.rangePaint(e.target);
  }

  rangePaint(range) {
    let percent = parseFloat(range.value) * 100.0;
    range.style.backgroundSize = `${percent}% 100%`;
  }

  addToNextListener(e) {
    console.log("ADD TO NEXT ITEM", e.detail);
    this.pushEvent("add-song", { id: e.detail.value.id });
  }

  playSongListener(e) {
    console.log("PLAY SONG", e.detail)

    this.pauseiconTarget.style.display = 'none'
    this.loadingiconTarget.style.display = 'block'
    this.playiconTarget.style.display = 'none'

    // this.el.dataset.playerPeaks = e.detail.peaks
    // this.el.dataset.playerUrl = e.detail.url
    this._wave.stop()
    // this generates a double play and thereof a memory bloat ....
    // this bug only happens when there is no store.playlist
    //this._wave.once('ready', () => this._wave.play())
    setTimeout(()=>{
      // this does nothing for now. We will improve this soon...
      // window.prependSongID(this.el.dataset.trackId)
      this._wave.load(this.el.dataset.playerUrl, JSON.parse(this.el.dataset.playerPeaks))
    }, 400)
  }

  waveClickListener(e) {
    setTimeout(()=>{
      const trackId = this.element.dataset.trackId
      const ev = new CustomEvent(`audio-process-${trackId}`, {
        detail: {
         position: this._wave.getCurrentTime(),
         percent: this._wave.getCurrentTime() / this._wave.getDuration()
       }
      });
      document.dispatchEvent(ev)

    }, 20)
  }

  mouseUpHandler(e) {
    if(e.detail.trackId == this.el.dataset.trackId){
      this._wave.seekTo(e.detail.percent)
      //this._wave.drawer.progress(e.detail.percent)
    }
  }

  audioPauseHandler(e) {
    if(e.detail.trackId == this.el.dataset.trackId){
      this._wave.pause()
    }
  }

  initWave() {
    this.peaks = this.peaksValue
    this.url = this.urlValue

    console.log("OELLELE", this.playerTarget)
    this._wave = WaveSurfer.create({
      container: this.playerTarget,
      autoplay: true,
      waveColor: 'grey',
      //progressColor: 'tomato',
      progressColor: 'white',
      height: 45,
      barWidth: 2,
      barGap: 3,
      responsive: true,
      //minPxPerSec: 2,
      pixelRatio: 10,
      //cursorWidth: 1,
      //cursorColor: "lightgray",
      volume: this.rangeTarget.value
    })

    window.w = this._wave

    this._wave.setVolume( window.store.getState().volume )

    const data = JSON.parse(this.peaksValue) 

    this._wave.load(this.urlValue, data)

    this._wave.on('pause', ()=> {
      this.dispatchPause()
    })

    this._wave.on('play', ()=> {
      console.log("play")
      this.dispatchPlay()
    })

    this._wave.on('audioprocess', (e)=> {
      const trackId = this.element.dataset.trackId
      const currentTime = this._wave.getCurrentTime();
      const duration = this._wave.getDuration();
      const percent = currentTime / duration;
      //console.log("AUDIO PROCESS", percent)

      if (percent >= 0.3 && !this.hasHalfwayEventFired) {
        this.hasHalfwayEventFired = true;
        this.trackEvent(trackId);
      }

      const ev = new CustomEvent(`audio-process-${trackId}`, {
        detail: {
          position: this._wave.getCurrentTime(), //this._wave.drawer.lastPos,
          percent: this._wave.getCurrentTime() / this._wave.getDuration()
        }
      });
      document.dispatchEvent(ev)
    })

    this._wave.on('ready', ()=> {
      console.log("PLAYER READY")
      // sends the progress position to track_component
      //this.playiconTarget.style.display = 'block'
      //this.loadingiconTarget.style.display = 'none'
      this._wave.getWrapper().addEventListener('click', this.waveClickListener)
    })


    // receives audio-process progress from track hook
    document.addEventListener('audio-process-mouseup', this.mouseUpHandler)

    // receives pause
    document.addEventListener('audio-pause', this.audioPauseHandler)
    

    this._wave.on('finish', (e) => {
      console.log("FINISH PROCESS")
      this.nextSong()
    })
  }

  dispatchPlay() {
    this.playiconTarget.style.display = 'block'
    this.loadingiconTarget.style.display = 'none'
    // this.loadingiconTarget.style.display = 'block'
    this.pauseiconTarget.style.display = 'none'

    const trackId = this.element.dataset.trackId
    const ev = new CustomEvent(`audio-process-${trackId}-play`, {
      detail: {}
    });
    document.dispatchEvent(ev)
  }

  dispatchPause() {
    this.playiconTarget.style.display = 'none'
    this.pauseiconTarget.style.display = 'block'
    this.loadingiconTarget.style.display = 'none'
    const trackId = this.element.dataset.trackId
    const ev = new CustomEvent(`audio-process-${trackId}-pause`, {
      detail: {}
    });
    document.dispatchEvent(ev)
  }

  destroyWave() {
    this._wave.destroy();
  }

  nextSong() {
    this.hasHalfwayEventFired = false;
    this.pushEvent("request-song", { action: "next" });
    console.log("no more songs to play");
  }

  prevSong() {
    this.hasHalfwayEventFired = false;
    this.pushEvent("request-song", { action: "prev" });
  }

  playSong() {
    this.hasHalfwayEventFired = false;
    this._wave.playPause();
  }

  trackEvent(trackId) {
    fetch(`/tracks/${trackId}/events`)
      .then(response => response.json())
      .then(data => console.log(data));
  }
}
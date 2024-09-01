import { Controller } from "@hotwired/stimulus";
import { get } from '@rails/request.js'

export default class extends Controller {
  static targets = [
    "audio",
    "playButton",
    "progress",
    "currentTime",
    "duration",
    "playIcon",
    "pauseIcon",
    "volumeSlider",
    "volumeOnIcon",
    "volumeOffIcon",
    "sidebar"
  ];

  connect() {
    this.audio = this.audioTarget;
    this.playButton = this.playButtonTarget;
    this.progress = this.progressTarget;
    this.currentTime = this.currentTimeTarget;
    this.duration = this.durationTarget;
    this.volumeSlider = this.volumeSliderTarget;
    this.volumeOnIcon = this.volumeOnIconTarget;
    this.volumeOffIcon = this.volumeOffIconTarget;

    this.audio.addEventListener("timeupdate", this.updateProgress.bind(this));
    this.audio.addEventListener("loadedmetadata", this.updateDuration.bind(this));

    // Automatically play the audio when it's loaded
    this.audio.addEventListener("loadeddata", this.autoPlay.bind(this));

    // Initialize volume level
    this.volumeSlider.value = window.store.getState().volume || this.audio.volume;

    // Initialize halfway tracking
    this.hasHalfwayEventFired = false;
  }

  autoPlay() {
    // Show loading animation (optional)
    const playPromise = this.audio.play();

    if (playPromise !== undefined) {
      playPromise
        .then(() => {
          // Automatic playback started!
          this.playIconTarget.classList.toggle("hidden")
          this.pauseIconTarget.classList.toggle("hidden")
        })
        .catch((error) => {
          // Auto-play was prevented
          console.error("Playback failed:", error);
          //this.playButton.textContent = "Play";
          this.playIconTarget.classList.toggle("hidden")
          this.pauseIconTarget.classList.toggle("hidden")
        });
    }
  }

  playPause() {
    if (this.audio.paused) {
      this.audio.play();
      //this.playButton.textContent = "Pause";
      this.playIconTarget.classList.toggle("hidden")
      this.pauseIconTarget.classList.toggle("hidden")
    } else {
      this.audio.pause();
      //this.playButton.textContent = "Play";
      this.playIconTarget.classList.toggle("hidden")
      this.pauseIconTarget.classList.toggle("hidden")
    }
  }

  setVolume() {
    this.audio.volume = this.volumeSlider.value;
    window.store.setState({ volume: this.volumeSlider.value })
    // Toggle volume icon
    if (this.audio.volume === 0) {
      this.volumeOnIcon.classList.add("hidden");
      this.volumeOffIcon.classList.remove("hidden");
    } else {
      this.volumeOnIcon.classList.remove("hidden");
      this.volumeOffIcon.classList.add("hidden");
    }
  }

  toggleMute() {
    if (this.audio.volume > 0) {
      this.audio.volume = 0;
      window.store.setState({ volume: 0 })
      this.volumeSlider.value = 0;
      this.volumeOnIcon.classList.add("hidden");
      this.volumeOffIcon.classList.remove("hidden");
    } else {
      this.audio.volume = 1;
      window.store.setState({ volume: 1 })
      this.volumeSlider.value = 1;
      this.volumeOnIcon.classList.remove("hidden");
      this.volumeOffIcon.classList.add("hidden");
    }
  }

  updateProgress() {
    const percent = (this.audio.currentTime / this.audio.duration) * 100;
    this.progress.style.width = `${percent}%`;
    this.currentTime.textContent = this.formatTime(this.audio.currentTime);
    // Check for halfway event trigger
    this.checkHalfwayEvent(percent);
  }

  checkHalfwayEvent(percent) {
    if (percent >= 30 && !this.hasHalfwayEventFired) {
      this.hasHalfwayEventFired = true;
      this.trackEvent(this.audio.dataset.trackId);  // Assuming the track ID is stored in a data attribute
    }
  }

  trackEvent(trackId) {
    fetch(`/tracks/${trackId}/events`, {
      method: "GET",  // Use POST to signify this is an event that is being recorded
      headers: {
        "Content-Type": "application/json",
        "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]').content
      },
      // body: JSON.stringify({ event: "halfway" })
    })
    .then(response => response.json())
    .then(data => console.log("Event tracked:", data))
    .catch(error => console.error("Error tracking event:", error));
  }


  updateDuration() {
    this.duration.textContent = this.formatTime(this.audio.duration);
  }

  seek(event) {
    const percent = event.offsetX / event.currentTarget.offsetWidth;
    this.audio.currentTime = percent * this.audio.duration;
  }

  formatTime(seconds) {
    const minutes = Math.floor(seconds / 60);
    const secs = Math.floor(seconds % 60);
    return `${minutes}:${secs < 10 ? "0" : ""}${secs}`;
  }

  closeSidebar(){
    this.sidebarTarget.classList.add("hidden")
  }

  toggleSidebar(){
    this.sidebarTarget.classList.toggle("hidden")
  }

  async nextSong() {
    this.hasHalfwayEventFired = false;
    const c = this.getNextTrackIndex();
    let aa = document.querySelector(`#sidebar-track-${c}`);

    if (!aa) {
      const otherController = this.application.getControllerForElementAndIdentifier(
        document.getElementById("track-detector"),
        "track-detector"
      );
      otherController.detect();
    }

    if (aa) {
      const response = await get(aa.dataset.url, {
        responseKind: "turbo-stream",
      });
      console.log("RESPONSE", response);
      console.log("Playing next song", c, aa);
    } else {
      console.log("No more songs to play", c, aa);
    }
  }

  async prevSong() {
    this.hasHalfwayEventFired = false;
    const c = this.getPreviousTrackIndex();
    let aa = document.querySelector(`#sidebar-track-${c}`);

    if (aa) {
      const response = await get(aa.dataset.url, {
        responseKind: "turbo-stream",
      });
      console.log("RESPONSE", response);
      console.log("Playing previous song", c, aa);
    } else {
      console.log("No more songs to play", c, aa);
    }
  }

  getNextTrackIndex() {
    const { playlist } = window.store.getState();
    const currentTrackId = this.idValue + "";
    const currentTrackIndex = playlist.indexOf(currentTrackId);

    if (currentTrackIndex === -1) return playlist[0];
    return currentTrackIndex === playlist.length - 1
      ? playlist[0]
      : playlist[currentTrackIndex + 1];
  }

  getPreviousTrackIndex() {
    const { playlist } = window.store.getState();
    const currentTrackId = this.idValue + "";
    const currentTrackIndex = playlist.indexOf(currentTrackId);

    if (currentTrackIndex === -1) return playlist[0];
    return currentTrackIndex === 0
      ? playlist[playlist.length - 1]
      : playlist[currentTrackIndex - 1];
  }
}


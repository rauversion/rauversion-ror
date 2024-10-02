
// app/javascript/controllers/ui_carousel_controller.js
import { Controller } from "@hotwired/stimulus"
import { useTransition } from 'stimulus-use'

export default class extends Controller {
  static targets = ["slide", "previousButton", "nextButton"]
  static values = {
    currentIndex: { type: Number, default: 0 },
    autoPlay: { type: Boolean, default: false },
    interval: { type: Number, default: 5000 } // 5 seconds
  }

  connect() {
    useTransition(this, {
      element: () => this.slideTargets[this.currentIndexValue],
      enterActive: 'transition ease-out duration-300',
      enterFrom: 'opacity-0',
      enterTo: 'opacity-100',
      leaveActive: 'transition ease-in duration-300',
      leaveFrom: 'opacity-100',
      leaveTo: 'opacity-0',
    })

    this.updateSlidePosition()
    this.updateButtonStates()

    if (this.autoPlayValue) {
      this.startAutoPlay()
    }
  }

  disconnect() {
    this.stopAutoPlay()
  }

  next() {
    this.currentIndexValue = (this.currentIndexValue + 1) % this.slideTargets.length
    this.updateSlidePosition()
    this.updateButtonStates()
  }

  previous() {
    this.currentIndexValue = (this.currentIndexValue - 1 + this.slideTargets.length) % this.slideTargets.length
    this.updateSlidePosition()
    this.updateButtonStates()
  }

  updateSlidePosition() {
    const offset = this.currentIndexValue * -100
    this.element.querySelector('.flex').style.transform = `translate3d(${offset}%, 0px, 0px)`
  }

  updateButtonStates() {
    if (this.hasPreviousButtonTarget && this.hasNextButtonTarget) {
      this.previousButtonTarget.disabled = this.currentIndexValue === 0
      this.nextButtonTarget.disabled = this.currentIndexValue === this.slideTargets.length - 1
    }
  }

  startAutoPlay() {
    this.autoPlayInterval = setInterval(() => {
      this.next()
    }, this.intervalValue)
  }

  stopAutoPlay() {
    if (this.autoPlayInterval) {
      clearInterval(this.autoPlayInterval)
    }
  }
}
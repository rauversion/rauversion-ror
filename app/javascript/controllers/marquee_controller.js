import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["marquee"];

  connect() {
    
  }

  marqueeTargetConected(element){

    debugger
    this.checkOverflow();
  }

  checkOverflow() {
    const marqueeElement = this.element
    const spanElement = marqueeElement.querySelector("span");
    debugger
    if (spanElement.scrollWidth > marqueeElement.clientWidth) {
      // The text overflows, apply marquee animation
      const overflowDistance = spanElement.scrollWidth - marqueeElement.clientWidth;
      const animationDuration = overflowDistance / 100; // Adjust speed by modifying the divisor (e.g., 100)

      spanElement.style.animationDuration = `${animationDuration}s`;
      marqueeElement.classList.add("marquee-active");
    } else {
      // The text doesn't overflow, disable marquee
      marqueeElement.classList.remove("marquee-active");
      // spanElement.style.animation = "none"; // Disable animation if not overflowing
    }
  }

}
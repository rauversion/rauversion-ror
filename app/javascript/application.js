// Entry point for the build script in your package.json
import "@hotwired/turbo-rails"

import create from 'zustand/vanilla'
import { persist } from 'zustand/middleware'


const store = create(
  persist(
    (set, get) => ({
      volume: 0.9,
      playlist: [],
      //addAFish: () => set({ fishes: get().fishes + 1 }),
    }),
    {
      name: 'rau-storage', // unique name
      getStorage: () => localStorage // sessionStorage, // (optional) by default, 'localStorage' is used
    }
  )
)

const { getState, setState, subscribe, destroy } = store

subscribe((v)=> {
  console.log("value changes", v)
})

// setState({fishes: 1})
window.store = store

window.dispatchMapsEvent = function (...args) {
  const event = document.createEvent("Events")
  event.initEvent("google-maps-callback", true, true)
  event.args = args
  window.dispatchEvent(event)
}

import "./controllers"

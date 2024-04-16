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
      name: 'rau-ror-storage', // unique name
      getStorage: () => localStorage // sessionStorage, // (optional) by default, 'localStorage' is used
    }
  )
)

const { getState, setState, subscribe, destroy } = store

if (!Array.isArray(store.getState().playlist)){
  store.setState({playlist: []})
}

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


Turbo.setConfirmMethod((message) => {
  let dialog = document.getElementById("data-turbo-confirm");
  dialog.showModal();
  document.getElementById("delete-message").textContent = message;
  return new Promise((resolve) =>{
    dialog.addEventListener("close", ()=>{
      resolve(dialog.returnValue == 'confirm')
    }, {once: true})
  })
})

import "./controllers"

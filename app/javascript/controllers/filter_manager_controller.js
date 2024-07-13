// app/javascript/controllers/filter_manager_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["filterForm", "filterList", "filterItem"]

  connect() {
    this.filterCount = this.filterItemTargets.length
  }

  addFilter(event) {
    event.preventDefault()
    const url = `/admin/${this.element.dataset.resourceName}/add_filter`
    const formData = new FormData(this.filterFormTarget)
    
    fetch(url, {
      method: 'POST',
      headers: {
        'Accept': 'text/vnd.turbo-stream.html',
        'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').content
      },
      body: formData
    })
    .then(response => response.text())
    .then(html => Turbo.renderStreamMessage(html))
    this.filterCount++
  }

  removeFilter(event) {
    event.preventDefault()
    const filterItem = event.target.closest('.filter-item')
    filterItem.remove()
    this.updateFilterIndices()
  }

  clearAll(event) {
    event.preventDefault()
    this.filterFormTarget.reset()
    this.filterItemTargets.slice(1).forEach(item => item.remove())
    this.filterCount = 1
  }

  updateFilterIndices() {
    this.filterItemTargets.forEach((item, index) => {
      item.querySelectorAll('select, input').forEach(element => {
        const name = element.getAttribute('name')
        if (name) {
          element.setAttribute('name', name.replace(/\[\d+\]/, `[${index}]`))
        }
      })
      const conditionSelect = item.querySelector('select[name$="[condition]"]')
      if (index === 0 && conditionSelect) {
        conditionSelect.closest('.mb-2').remove()
      } else if (index > 0 && !conditionSelect) {
        item.insertAdjacentHTML('afterbegin', `
          <div class="mb-2">
            <select name="admin_filter_form[filters][${index}][condition]" class="mr-2">
              <option value="AND">AND</option>
              <option value="OR">OR</option>
            </select>
          </div>
        `)
      }
    })
    this.filterCount = this.filterItemTargets.length
  }
}
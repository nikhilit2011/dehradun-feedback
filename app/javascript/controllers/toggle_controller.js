import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  toggle(event) {
    const field = document.getElementById("other-issue-field")
    if (event.target.checked) {
      field.classList.remove("hidden")
    } else {
      field.classList.add("hidden")
    }
  }
}

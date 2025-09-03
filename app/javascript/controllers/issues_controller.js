import { Controller } from "@hotwired/stimulus"

// data-controller="issues"
export default class extends Controller {
  static targets = ["othersCheckbox", "otherField"]

  toggleOther() {
    console.log("toggleOther fired!") // debug
    if (this.othersCheckboxTarget.checked) {
      this.otherFieldTarget.classList.remove("hidden")
    } else {
      this.otherFieldTarget.classList.add("hidden")
    }
  }
}

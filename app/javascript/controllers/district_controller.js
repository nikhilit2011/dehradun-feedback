import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["districtSelect", "schoolSelect"]

  connect() {
    const districtId = this.districtSelectTarget?.value
    const preselectId = this.schoolSelectTarget?.dataset.selected
    if (districtId) {
      this.loadSchools(districtId, preselectId)
    } else {
      this.resetSchool()
    }
  }

  filterSchools() {
    const districtId = this.districtSelectTarget.value
    if (!districtId) {
      this.resetSchool()
      return
    }
    this.loadSchools(districtId)
  }

  resetSchool() {
    if (!this.hasSchoolSelectTarget) return
    this.schoolSelectTarget.disabled = true
    this.schoolSelectTarget.innerHTML = `<option value="">Select School</option>`
  }

  async loadSchools(districtId, preselectId = null) {
    if (!this.hasSchoolSelectTarget) return
    this.schoolSelectTarget.disabled = true
    this.schoolSelectTarget.innerHTML = `<option value="">Loading…</option>`

    try {
      const resp = await fetch(`/districts/${districtId}/schools.json`, {
        headers: { Accept: "application/json" },
        credentials: "same-origin",
      })
      const schools = await resp.json()

      this.schoolSelectTarget.innerHTML = `<option value="">Select School</option>`
      schools.forEach((s) => {
        const opt = document.createElement("option")
        opt.value = s.id
        opt.textContent = s.name
        if (preselectId && String(preselectId) === String(s.id)) opt.selected = true
        this.schoolSelectTarget.appendChild(opt)
      })

      this.schoolSelectTarget.disabled = false
    } catch (e) {
      this.schoolSelectTarget.innerHTML = `<option value="">Unable to load schools</option>`
      this.schoolSelectTarget.disabled = true
    }
  }
}

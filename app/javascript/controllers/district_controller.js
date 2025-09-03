import { Controller } from "@hotwired/stimulus"

console.log("🚀 district_controller.js file loaded")

// Connects to data-controller="district"
export default class extends Controller {
  static targets = ["districtSelect", "schoolSelect"]

  connect() {
    console.log("✅ district_controller connected")
    const districtId = this.districtSelectTarget?.value
    const preselectId = this.schoolSelectTarget?.dataset.selected

    console.log("Initial districtId:", districtId, "preselectId:", preselectId)

    if (districtId) {
      this.loadSchools(districtId, preselectId)
    } else {
      this.resetSchool()
    }
  }

  filterSchools() {
    const districtId = this.districtSelectTarget.value
    console.log("📌 District changed to:", districtId)

    if (!districtId) {
      this.resetSchool()
      return
    }
    this.loadSchools(districtId)
  }

  resetSchool() {
    if (!this.hasSchoolSelectTarget) return
    console.log("🔄 Resetting school dropdown")
    this.schoolSelectTarget.disabled = true
    this.schoolSelectTarget.innerHTML = `<option value="">Select School</option>`
  }

  async loadSchools(districtId, preselectId = null) {
    if (!this.hasSchoolSelectTarget) return
    console.log("⏳ Loading schools for district:", districtId)

    this.schoolSelectTarget.disabled = true
    this.schoolSelectTarget.innerHTML = `<option value="">Loading…</option>`

    try {
      const resp = await fetch(`/districts/${districtId}/schools.json`, {
        headers: { Accept: "application/json" },
        credentials: "same-origin",
      })

      console.log("🔍 Response status:", resp.status)
      if (!resp.ok) throw new Error(`HTTP error ${resp.status}`)

      const schools = await resp.json()
      console.log("✅ Fetched schools:", schools)

      // Reset dropdown
      this.schoolSelectTarget.innerHTML = `<option value="">Select School</option>`

      // Add schools
      if (Array.isArray(schools)) {
        schools.forEach((s) => {
          const opt = document.createElement("option")
          opt.value = s.id
          opt.textContent = s.name
          if (preselectId && String(preselectId) === String(s.id)) {
            opt.selected = true
          }
          this.schoolSelectTarget.appendChild(opt)
        })
      }

      // ✅ Always append "Other" option
      const otherOpt = document.createElement("option")
      otherOpt.value = "other"
      otherOpt.textContent = "Other"
      if (preselectId === "other") otherOpt.selected = true
      this.schoolSelectTarget.appendChild(otherOpt)

      this.schoolSelectTarget.disabled = false
      console.log("🎯 Final school dropdown:", this.schoolSelectTarget.innerHTML)
    } catch (e) {
      console.error("❌ Error loading schools:", e)
      this.schoolSelectTarget.innerHTML = `<option value="">Unable to load schools</option>`
      this.schoolSelectTarget.disabled = true
    }
  }
}

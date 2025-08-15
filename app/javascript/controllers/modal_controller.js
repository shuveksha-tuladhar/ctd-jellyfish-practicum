
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  open(event) {
    event.preventDefault()
    fetch("/expenses/new", { headers: { "Turbo-Frame": "modal" } })
      .then(res => res.text())
      .then(html => {
        document.getElementById("modal").innerHTML = html
      })
  }

  close(event) {
    event.preventDefault()
    document.getElementById("modal").innerHTML = ""
  }
}

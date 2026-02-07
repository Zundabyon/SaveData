// app/javascript/controllers/game_modal_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["modal", "title", "meta", "memo", "edit", "delete"]

  open(event) {
    const button = event.currentTarget
    const title = button.dataset.title
    const meta = button.dataset.meta
    const memo = button.dataset.memo
    const gameId = button.dataset.gameId

    this.titleTarget.innerText = title
    this.metaTarget.innerText = meta
    this.memoTarget.innerText = memo || "……"

    this.editTarget.href = `/games/${gameId}/edit`
    this.deleteTarget.href = `/games/${gameId}/confirm_destroy`

    this.modalTarget.classList.remove("hidden")
    this.modalTarget.classList.add("flex")
  }

  close() {
    this.modalTarget.classList.add("hidden")
    this.modalTarget.classList.remove("flex")
  }
}
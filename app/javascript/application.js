import "@hotwired/turbo-rails"
import "./controllers"

window.openModal = function(title, meta, memo, gameId) {
  const modal = document.getElementById("game-modal")
  if (!modal) return

  document.body.classList.add("overflow-hidden")

  document.getElementById("modal-title").textContent = title
  document.getElementById("modal-meta").textContent = meta
  document.getElementById("modal-memo").textContent = memo || "……"

  document.getElementById("edit-link").href = `/games/${gameId}/edit`
  document.getElementById("delete-link").href = `/games/${gameId}/confirm_destroy`

  modal.classList.remove("hidden")
  modal.classList.add("flex")
}

window.closeModal = function() {
  const modal = document.getElementById("game-modal")
  if (!modal) return

  document.body.classList.remove("overflow-hidden")
  modal.classList.add("hidden")
  modal.classList.remove("flex")
}

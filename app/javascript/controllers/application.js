import { Application } from "@hotwired/stimulus"

const application = Application.start()

// Configure Stimulus development experience
application.debug = false
window.Stimulus   = application

export { application }

window.openModalFromElement = function (el) {
  const title = el.dataset.title
  const meta = el.dataset.meta
  const memo = el.dataset.memo
  const gameId = el.dataset.gameId

  openModal(title, meta, memo, gameId)
}


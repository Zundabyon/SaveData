window.openModal = function(title, meta, memo, gameId) {
  window.currentGameId = gameId

  const modal = document.getElementById('gameModal')
  const modalContent = modal.querySelector('div > div')

  document.getElementById('modalTitle').innerText = title
  document.getElementById('modalMeta').innerText = meta
  document.getElementById('modalMemo').innerText = memo || "……"
  document.getElementById('modalEdit').href = `/games/${gameId}/edit`
  document.getElementById('modalDelete').href = `/games/${gameId}/confirm_destroy`

  modal.classList.remove('hidden')
  modal.classList.add('flex')

  setTimeout(() => {
    modalContent.classList.remove('scale-95', 'opacity-0')
    modalContent.classList.add('scale-100', 'opacity-100')
  }, 10)
}

window.closeModal = function() {
  const modal = document.getElementById('gameModal')
  const modalContent = modal.querySelector('div > div')

  modalContent.classList.remove('scale-100', 'opacity-100')
  modalContent.classList.add('scale-95', 'opacity-0')

  setTimeout(() => {
    modal.classList.add('hidden')
    modal.classList.remove('flex')
  }, 300)
}

document.addEventListener('turbo:load', function() {
  const modal = document.getElementById('gameModal')
  if (modal) {
    modal.addEventListener('click', function(e) {
      if (e.target === modal) {
        closeModal()
      }
    })
  }

  const progressBars = document.querySelectorAll('[data-width]')
  progressBars.forEach(bar => {
    const width = bar.getAttribute('data-width')
    setTimeout(() => {
      bar.style.width = width + '%'
    }, 100)
  })
})

// Entry point for the build script in your package.json
import "@hotwired/turbo-rails"
import "./controllers"

// モーダルを開く
window.openModal = function(title, meta, memo, gameId) {
  const modal = document.getElementById('game-modal');
  const modalTitle = document.getElementById('modal-title');
  const modalMeta = document.getElementById('modal-meta');
  const modalMemo = document.getElementById('modal-memo');
  const editLink = document.getElementById('edit-link');
  const deleteLink = document.getElementById('delete-link');

  modalTitle.textContent = title;
  modalMeta.textContent = meta;
  modalMemo.textContent = memo || "……";
  
  editLink.href = `/games/${gameId}/edit`;
  deleteLink.href = `/games/${gameId}/confirm_destroy`;

  modal.classList.remove('hidden');
  modal.classList.add('flex');
};

// モーダルを閉じる
window.closeModal = function() {
  const modal = document.getElementById('game-modal');
  modal.classList.add('hidden');
  modal.classList.remove('flex');
};
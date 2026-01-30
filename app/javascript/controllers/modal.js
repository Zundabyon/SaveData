// モーダルを開く
window.openModal = function(title, subtitle, memo, gameId) {
  const modal = document.getElementById('gameModal');
  const modalTitle = document.getElementById('modalTitle');
  const modalSubtitle = document.getElementById('modalSubtitle');
  const modalMemo = document.getElementById('modalMemo');
  const editLink = document.getElementById('editLink');
  const deleteLink = document.getElementById('deleteLink');

  modalTitle.textContent = title;
  modalSubtitle.textContent = subtitle;
  modalMemo.textContent = memo;

  editLink.href = `/games/${gameId}/edit`;
  deleteLink.href = `/games/${gameId}`;

  modal.classList.remove('hidden');
  modal.classList.add('flex');
};

// モーダルを閉じる
window.closeModal = function() {
  const modal = document.getElementById('gameModal');
  modal.classList.add('hidden');
  modal.classList.remove('flex');
};

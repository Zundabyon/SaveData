// Rails 7+ importmap用
import "@hotwired/turbo-rails"
import "./controllers" // ここで controllers/index.js を読み込む

document.addEventListener('turbo:load', () => {
  setupDragAndDrop();
});

function setupDragAndDrop() {
  const dropZones = document.querySelectorAll('.drop-zone');
  dropZones.forEach(dropZone => {
    const fileInput = dropZone.querySelector('input[type="file"]');
    if (!fileInput) return;
    // ドラッグイベントのデフォルト動作を防止
    ['dragenter', 'dragover', 'dragleave', 'drop'].forEach(eventName => {
      dropZone.addEventListener(eventName, preventDefaults, false);
      document.body.addEventListener(eventName, preventDefaults, false);
    });
    // ハイライト表示
    ['dragenter', 'dragover'].forEach(eventName => {
      dropZone.addEventListener(eventName, () => {
        dropZone.classList.add('border-blue-500', 'bg-blue-50');
      }, false);
    });

    ['dragleave', 'drop'].forEach(eventName => {
      dropZone.addEventListener(eventName, () => {
        dropZone.classList.remove('border-blue-500', 'bg-blue-50');
      }, false);
    });

    // ドロップ処理
    dropZone.addEventListener('drop', (e) => {
      const files = e.dataTransfer.files;
      fileInput.files = files;
      // プレビュー表示をトリガー
      const event = new Event('change', { bubbles: true });
      fileInput.dispatchEvent(event);
    }, false);
  });
}

function preventDefaults(e) {
  e.preventDefault();
  e.stopPropagation();
}

// Rails 7+ importmap用
import "@hotwired/turbo-rails"
console.log("Turbo loaded");

import "./controllers"

// 共通で使うオーバーレイ取得関数
const getOverlay = () => document.getElementById("loading-overlay");

// --- ドラッグ&ドロップの設定 ---
document.addEventListener('turbo:load', () => {
  setupDragAndDrop();
});

// --- ローディング演出の設定 ---

// ページロード時にローディングを表示
document.addEventListener('DOMContentLoaded', () => {
  console.log("DOMContentLoaded fired - showing loading");
  const overlay = getOverlay();
  console.log("overlay element:", overlay);
  if (overlay) {
    overlay.classList.remove("invisible", "opacity-0");
    overlay.classList.add("opacity-100");
    setTimeout(() => {
      console.log("hiding loading");
      overlay.classList.remove("opacity-100");
      overlay.classList.add("opacity-0", "invisible");
    }, 3000); // 3秒表示
  } else {
    console.log("overlay not found");
  }
});

// 1. ページ遷移の開始
document.addEventListener("turbo:before-visit", () => {
  console.log("turbo:before-visit triggered");
  const overlay = getOverlay();
  if (overlay) {
    overlay.classList.remove("invisible", "opacity-0");
    overlay.classList.add("opacity-100");
  }
});

// 2. フォーム送信時
document.addEventListener("turbo:submit-start", () => {
  console.log("turbo:submit-start triggered");
  const overlay = getOverlay();
  if (overlay) {
    overlay.classList.remove("invisible", "opacity-0");
    overlay.classList.add("opacity-100");
  }
});

// 3. 読み込み完了（非表示にする）
document.addEventListener("turbo:load", () => {
  console.log("turbo:load triggered");
  const overlay = getOverlay();
  if (overlay) {
    setTimeout(() => {
      overlay.classList.remove("opacity-100");
      overlay.classList.add("opacity-0", "invisible");
    }, 2000); // 2秒に延長して確認
  }
});

// 4. 【重要】キャッシュ対策
// Turboは遷移直前の状態をキャッシュするため、
// 表示したままキャッシュされると「戻る」時にスライムが残ってしまいます。
document.addEventListener("turbo:before-cache", () => {
  const overlay = getOverlay();
  if (overlay) overlay.classList.add("invisible", "opacity-0");
});

// 5. フォーム送信エラーなどの場合も非表示に戻す
document.addEventListener("turbo:submit-end", () => {
  // ロードが終わったとみなして隠す（エラー表示などはこの後に出るため）
  const overlay = getOverlay();
  if (overlay) {
    overlay.classList.remove("opacity-100");
    overlay.classList.add("opacity-0", "invisible");
  }
});

// --- ドラッグ&ドロップの関数 ---
function setupDragAndDrop() {
  const dropZones = document.querySelectorAll('.drop-zone');
  dropZones.forEach(dropZone => {
    const fileInput = dropZone.querySelector('input[type="file"]');
    if (!fileInput) return;

    ['dragenter', 'dragover', 'dragleave', 'drop'].forEach(eventName => {
      dropZone.addEventListener(eventName, preventDefaults, false);
    });

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

    dropZone.addEventListener('drop', (e) => {
      const files = e.dataTransfer.files;
      fileInput.files = files;
      const event = new Event('change', { bubbles: true });
      fileInput.dispatchEvent(event);
    }, false);
  });
}

function preventDefaults(e) {
  e.preventDefault();
  e.stopPropagation();
}
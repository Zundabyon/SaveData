import html2canvas from "html2canvas"

window.shareCard = function(gameId) {
  const card = document.getElementById(`game-card-${gameId}`)

  // 先にウィンドウを開く（ポップアップブロック対策）
  const tweetWindow = window.open('', '_blank')

  html2canvas(card, {
    useCORS: true,
    allowTaint: true,
    scale: 1
  }).then(canvas => {
    const imageData = canvas.toDataURL('image/png')

    fetch('/share_images', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').content
      },
      body: JSON.stringify({ image: imageData })
    })
    .then(res => res.json())
    .then(data => {
      fetch(`https://tinyurl.com/api-create.php?url=${encodeURIComponent(data.url)}`)
        .then(res => res.text())
        .then(shortUrl => {
          const tweetUrl = `https://twitter.com/intent/tweet?text=SaveDataでゲームの思い出を記録したよ！%0A${encodeURIComponent(shortUrl)}`
          tweetWindow.location.href = tweetUrl
        })
    })
    .catch(e => console.log('エラー:', e))
  })
}
import html2canvas from "html2canvas"

window.shareCard = function(gameId) {
  const card = document.getElementById(`game-card-${gameId}`)

  html2canvas(card, { useCORS: true, allowTaint: true }).then(canvas => {
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
      // TinyURLで短縮
      fetch(`https://tinyurl.com/api-create.php?url=${encodeURIComponent(data.url)}`)
        .then(res => res.text())
        .then(shortUrl => {
          const tweetUrl = `https://twitter.com/intent/tweet?text=SaveDataでゲームの思い出を記録したよ！%0A${encodeURIComponent(shortUrl)}`
          window.open(tweetUrl, '_blank')
        })
    })
    .catch(e => console.log('エラー:', e)) // ← 追加
  })
}
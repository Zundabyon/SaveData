import html2canvas from "html2canvas"

window.shareCard = function(gameId) {
  const card = document.getElementById(`game-card-${gameId}`)
  const userName = card.dataset.userName
  const gameTitle = card.dataset.gameTitle.slice(0, 20)

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
          const tweetText = `${userName}の冒険の記録\n「${gameTitle}」\n#SaveData\n宝箱を開ける👉${shortUrl}`
          const tweetUrl = `https://twitter.com/intent/tweet?text=${encodeURIComponent(tweetText)}`
          tweetWindow.location.href = tweetUrl
        })
    })
    .catch(e => console.log('エラー:', e))
  })
}
// app/javascript/controllers/game_modal_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["modal", "title", "meta", "memo", "editLink", "deleteLink"]

  open(event) {
    event.preventDefault()
    const card = event.currentTarget

    // データ属性から情報を取得
    const title = card.dataset.gameTitle
    const age = card.dataset.gameAge
    const hardware = card.dataset.gameHardware
    const genre = card.dataset.gameGenre
    const difficulty = card.dataset.gameDifficulty
    const fun = card.dataset.gameFun
    const memo = card.dataset.gameMemo
    const editPath = card.dataset.gameEditPath
    const deletePath = card.dataset.gameDeletePath

    // モーダルに情報を設定
    this.titleTarget.textContent = title
    this.metaTarget.textContent = `${age}歳 | ${hardware} | ${genre}`
    this.memoTarget.textContent = memo || "感想が記録されていません"
    this.editLinkTarget.href = editPath
    this.deleteLinkTarget.href = deletePath

    // モーダルを表示
    this.modalTarget.classList.remove("hidden")
    this.modalTarget.classList.add("flex")
  }

  close(event) {
    event.preventDefault()
    this.modalTarget.classList.add("hidden")
    this.modalTarget.classList.remove("flex")
  }

  // モーダル外クリックで閉じる
  closeOnBackdrop(event) {
    if (event.target === this.modalTarget) {
      this.close(event)
    }
  }
}
import { Application } from "@hotwired/stimulus"
import GameModalController from "./game_modal_controller"

// Stimulus起動
const application = Application.start()
application.register("game-modal", GameModalController)

// windowに置くことでブラウザからもアクセス可能
window.Stimulus = application

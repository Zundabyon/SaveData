module ApplicationHelper


def job_image_filename(job)
  job_images = {
    "せんし" => "warrior.png", "まほうつかい" => "mage.png",
    "とうぞく" => "thief.png", "そうりょ" => "priest.png",
    "ゆうしゃ" => "fighter.png", "しにがみ" => "devil.png",
    "Figmaしょくにん" => "figma_master.png", "ロブスター" => "lobster.png",
    "その他" => "other.png",
    "warrior" => "warrior.png", "mage" => "mage.png",
    "thief" => "thief.png", "priest" => "priest.png",
    "fighter" => "fighter.png", "devil" => "devil.png",
    "figma_master" => "figma_master.png", "lobster" => "lobster.png",
    "other" => "other.png"
  }
  job_images[job] || "other.png"
end

end

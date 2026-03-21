module UsersHelper
  def job_hiragana(job)
    {
      "warrior" => "せんし",
      "mage" => "まほうつかい",
      "thief" => "とうぞく",
      "priest" => "そうりょ",
      "fighter" => "ゆうしゃ",
      "devil" => "しにがみ",
      "figma_master" => "ふぃぐましょくにん",
      "lobster" => "ろぶすたー",
      "other" => "そのた"
    }[job] || "むしょく"
  end
end

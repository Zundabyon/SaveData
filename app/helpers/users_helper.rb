module UsersHelper
  def era_title(year)
    case year
    when 1980..1989 then "黎明期"
    when 1990..1994 then "幼年期"
    when 1995..1999 then "成長期"
    when 2000..2009 then "円熟期"
    else "現在"
    end
  end
end

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

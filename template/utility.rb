# coding: utf-8


class Element

  DEBUG_COLORS = ["#FF888888", "#8888FF88", "#88FF8888", "#FF88FF88"]

  def make_elastic(clazz)
    original_space = self[clazz]
    self["#{clazz}.maximum"] = "(#{original_space}) * #{MAXIMUM_RATIO}"
    self["#{clazz}.minimum"] = "(#{original_space}) * #{MINIMUM_RATIO}"
  end

  def reset_indent
    self["start-indent"] = "0mm"
    self["end-indent"] = "0mm"
  end

  def justify_text
    self["text-align"] = "justify"
    self["axf:text-justify-trim"] = "punctuation ideograph inter-word"
  end

  # アクセントに用いている Gill Sans Nova フォントの上下の位置を修正します。
  # このフォントはディセントが大きいため、ディセンダーがない文字のみで組むと少し上に浮いているような見た目になります。
  # このメソッドにより、文字の位置を少し下にずらし、文字が浮いてしまうのを防ぐことができます。
  def fix_text_position
    self["relative-position"] = "relative"
    self["top"] = "0.1em"
  end

  def debug(number)
    self["background-color"] = DEBUG_COLORS[number]
  end

  def self.build_page_master(&block)
    this = Nodes[]
    this << Element.build("fo:simple-page-master") do |this|
      this["page-width"] = PAGE_WIDTH
      this["page-height"] = PAGE_HEIGHT
      this["axf:bleed"] = BLEED_SIZE
      if DEBUG
        this["background-image"] = "url('../material/blank.svg')"
        this["background-repeat"] = "no-repeat"
      end
      block&.call(this)
    end
    return this
  end

  def self.build_spread_page_master(&block)
    this = Nodes[]
    this << Element.build("axf:spread-page-master") do |this|
      block&.call(this)
    end
    return this
  end

  def self.build_region_body(position, &block)
    this = Nodes[]
    this << Element.build("fo:region-body") do |this|
      this["margin-top"] = PAGE_TOP_SPACE
      this["margin-bottom"] = PAGE_BOTTOM_SPACE
      this["margin-left"] = (position == :left) ? PAGE_OUTER_SPACE : PAGE_INNER_SPACE
      this["margin-right"] = (position == :left) ? PAGE_INNER_SPACE : PAGE_OUTER_SPACE
      block&.call(this)
    end
    return this
  end

  def self.build_spread_region(&block)
    this = Nodes[]
    this << Element.build("axf:spread-region") do |this|
      this["margin-top"] = PAGE_TOP_SPACE
      this["margin-bottom"] = PAGE_BOTTOM_SPACE
      this["margin-left"] = PAGE_OUTER_SPACE 
      this["margin-right"] = PAGE_OUTER_SPACE
      block&.call(this)
    end
    return this
  end

  def self.build_region_before(&block)
    this = Nodes[]
    this << Element.build("fo:region-before") do |this|
      this["extent"] = PAGE_TOP_SPACE
      this["precedence"] = "true"
      block&.call(this)
    end
    return this
  end

  def self.build_region_after(&block)
    this = Nodes[]
    this << Element.build("fo:region-after") do |this|
      this["extent"] = PAGE_BOTTOM_SPACE
      this["precedence"] = "true"
      block&.call(this)
    end
    return this
  end

  def self.build_region_start(position, &block)
    this = Nodes[]
    this << Element.build("fo:region-start") do |this|
      this["extent"] = (position == :left) ? PAGE_OUTER_SPACE : PAGE_INNER_SPACE
      block&.call(this)
    end
    return this
  end

  def self.build_region_end(position, &block)
    this = Nodes[]
    this << Element.build("fo:region-end") do |this|
      this["extent"] = (position == :left) ? PAGE_INNER_SPACE : PAGE_OUTER_SPACE
      block&.call(this)
    end
    return this
  end

end


module Shaleian

  def self.divide(string)
    string = string.clone
    string.gsub!("'", "")
    string.gsub!("-", "")
    string = string.split(//).reverse.map{|s| "<#{s}>"}.join
    string.gsub!(/((<[sztdkgfvpbcqxjrlmnhy]>)?<[aeiouâêîôûáéíàèìòù]>(<[sztdkgfvpbcqxjrlmnhy]>)?)/){$1 + "."}
    string = string.scan(/(<.>|\.)/).reverse.join
    if string[0..0] == "."
      string[0] = "" 
    end
    return string
  end

  def self.pronunciation(string)
    string = Shaleian.divide(string)
    string = "kiɴ" if string == "<k><i><n>"
    string = "aɪ" if string == "<á>"
    string = "eɪ" if string == "<é>"
    string = "aʊ" if string == "<à>"
    string = "laɪ" if string == "<l><á>"
    string = "leɪ" if string == "<l><é>"
    string = "daʊ" if string == "<d><à>"
    string = "l" if string == "<l>"
    string = "ɴ" if string == "<n>"
    string.gsub!(/<(s|z|t|d|k|g|f|v|p|b|c|q|x|j|r|l|m|n|h|y)>.<\1>/){".<#{$1}>"}
    string.gsub!("<s>", "s")
    string.gsub!("<z>", "z")
    string.gsub!("<t>", "t")
    string.gsub!("<d>", "d")
    string.gsub!("<k>", "k")
    string.gsub!("<g>", "ɡ")
    string.gsub!("<f>", "f")
    string.gsub!("<v>", "v")
    string.gsub!("<p>", "p")
    string.gsub!("<b>", "b")
    string.gsub!("<c>", "θ")
    string.gsub!("<q>", "ð")
    string.gsub!("<x>", "ʃ")
    string.gsub!("<j>", "ʒ")
    string.gsub!("<r>", "ɹ")
    string.gsub!(/<l><(a|e|i|o|u|â|ê|î|ô|û|á|é|í|à|è|ì|ò|ù)>/){"l<#{$1}>"}
    string.gsub!("<l>", "ɾ")
    string.gsub!("<m>", "m")
    string.gsub!("<n>", "n")
    string.gsub!(/<h>(\.|$)/){$1}
    string.gsub!(/<h><(a|e|i|o|u|â|ê|î|ô|û|á|é|í|à|è|ì|ò|ù)>/){"h<#{$1}>"}
    string.gsub!("<h>", "")
    string.gsub!("<y>", "j")
    string.gsub!("<a>", "a")
    string.gsub!("<e>", "e")
    string.gsub!("<i>", "i")
    string.gsub!("<o>", "ɔ")
    string.gsub!("<u>", "u")
    string.gsub!("<â>", "a")
    string.gsub!("<ê>", "e")
    string.gsub!("<î>", "i")
    string.gsub!("<ô>", "ɔ")
    string.gsub!("<û>", "u")
    string.gsub!("<á>", "a")
    string.gsub!("<é>", "e")
    string.gsub!("<í>", "i")
    string.gsub!("<à>", "a")
    string.gsub!("<è>", "e")
    string.gsub!("<ì>", "i")
    string.gsub!("<ò>", "ɔ")
    string.gsub!("<ù>", "u")
    string.gsub!(/<.>/, "")
    string.gsub!(".", "")
    return string
  end

end
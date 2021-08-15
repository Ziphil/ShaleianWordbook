# coding: utf-8


converter.set("page-number") do |element, position|
  this = Nodes[]
  this << Element.build("fo:block-container") do |this|
    this["height"] = "#{FOOTER_EXTENT} + #{BLEED_SIZE}"
    this["margin-bottom"] = "-1 * #{BLEED_SIZE}"
    this["margin-left"] = "-1 * #{BLEED_SIZE}"
    this["margin-right"] = "-1 * #{BLEED_SIZE}"
    this << Element.build("fo:block-container") do |this|
      this["bottom"] = "8mm + #{BLEED_SIZE}"
      this["#{position}"] = "8mm + #{BLEED_SIZE}"
      this.reset_indent
      this["width"] = "10mm"
      this["font-family"] = SPECIAL_FONT_FAMILY
      this["font-size"] = "1.2em"
      this["font-weight"] = "bold"
      this["text-align"] = "#{position}"
      this["display-align"] = "after"
      this["absolute-position"] = "absolute"
      this << Element.build("fo:block") do |this|
        this.fix_text_position
        this << Element.new("fo:page-number")
      end
    end
  end
  next this
end
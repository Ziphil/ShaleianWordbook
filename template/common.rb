# coding: utf-8


converter.set("page-number") do |element, position|
  this = Nodes[]
  this << Element.build("fo:block-container") do |this|
    this["height"] = "#{FOOTER_EXTENT} + #{BLEED_SIZE}"
    this["margin-bottom"] = "-1 * #{BLEED_SIZE}"
    this["margin-left"] = "-1 * #{BLEED_SIZE}"
    this["margin-right"] = "-1 * #{BLEED_SIZE}"
    this << Element.build("fo:block-container") do |this|
      this["width"] = "9mm"
      this["height"] = "#{FOOTER_EXTENT} + #{BLEED_SIZE}"
      this["bottom"] = "0mm"
      if position == :left
        this["left"] = "8mm + #{BLEED_SIZE}"
      else
        this["right"] = "8mm + #{BLEED_SIZE}"
      end
      this["font-family"] = SPECIAL_FONT_FAMILY
      this["font-size"] = "1.1em"
      this["color"] = "white"
      this["text-align"] = "center"
      this["axf:border-top-left-radius"] = "2mm"
      this["axf:border-top-right-radius"] = "2mm"
      this["background-color"] = BORDER_COLOR
      this["absolute-position"] = "absolute"
      this << Element.build("fo:block") do |this|
        this["padding-before"] = "1mm"
        this << Element.new("fo:page-number")
      end
    end
    this << Element.build("fo:block-container") do |this|
      this["top"] = "0mm"
      if position == :left
        this["left"] = "17mm + #{BLEED_SIZE}"
      else
        this["right"] = "17mm + #{BLEED_SIZE}"
      end
      this["margin-left"] = "0.5em"
      this["margin-right"] = "0.5em"
      this["font-size"] = "0.9em"
      if position == :left
        this["text-align"] = "left"
      else
        this["text-align"] = "right"
      end
      this["absolute-position"] = "absolute"
      this << Element.build("fo:block") do |this|
        this["padding-before"] = "0.8mm"
        this << Element.build("fo:retrieve-marker") do |this|
          this["retrieve-class-name"] = "section"
        end
      end
    end
  end
  next this
end
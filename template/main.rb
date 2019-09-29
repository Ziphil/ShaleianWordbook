# coding: utf-8


DEBUG = true

EUROPIAN_FONT_FAMILY = "Linux Libertine"
JAPANESE_FONT_FAMILY = "源ノ明朝"
EUROPIAN_SHALEIA_FONT_FAMILY = "Vekos"
JAPANESE_SHALEIA_FONT_FAMILY = "源ノ角ゴシック"
EUROPIAN_SANS_FONT_FAMILY = "FreeSans"
JAPANESE_SANS_FONT_FAMILY = "源ノ角ゴシック"
SPECIAL_FONT_FAMILY = "Gill Sans Nova Cond Bold"

FONT_SIZE = "8pt"
SHALEIA_FONT_SIZE = "100%"
SANS_FONT_SIZE = "95%"
LINE_HEIGHT = "1.4"

PAGE_WIDTH = "128mm"
PAGE_HEIGHT = "182mm"
PAGE_TOP_SPACE = "15mm"
PAGE_BOTTOM_SPACE = "15mm"
PAGE_INNER_SPACE = "22mm"
PAGE_OUTER_SPACE = "17mm"
HEADER_EXTENT = "15mm"
FOOTER_EXTENT = "15mm"
SIDE_EXTENT = "11mm"
BLEED_SIZE = "0mm"

MAXIMUM_RATIO = "2"
MINIMUM_RATIO = "0.8"
BORDERED_SPACE_RATIO = "1.5"

BORDER_WIDTH = "0.2mm"
TEXT_BORDER_WIDTH = "0.1mm"
BORDER_RADIUS = "1mm"

TEXT_COLOR = "rgb-icc(#CMYK, 0, 0, 0, 1)"
RED_TEXT_COLOR = "rgb-icc(#CMYK, 0, 0.8, 0, 0)"
BORDER_COLOR = "rgb-icc(#CMYK, 0, 0.5, 0, 0.5)"
BACKGROUND_COLOR = "rgb-icc(#CMYK, 0, 0.2, 0, 0)"

FONT_FAMILY = EUROPIAN_FONT_FAMILY + ", " + JAPANESE_FONT_FAMILY
SHALEIA_FONT_FAMILY = EUROPIAN_SHALEIA_FONT_FAMILY + ", " + JAPANESE_SHALEIA_FONT_FAMILY
SANS_FONT_FAMILY = EUROPIAN_SANS_FONT_FAMILY + ", " + JAPANESE_SANS_FONT_FAMILY

converter.add(["root"], [""]) do |element|
  this = Nodes[]
  this << Element.build("fo:root") do |this|
    this["xmlns:fo"] = "http://www.w3.org/1999/XSL/Format"
    this["xmlns:axf"] = "http://www.antennahouse.com/names/XSL/Extensions"
    this["xml:lang"] = "ja"
    this["font-family"] = FONT_FAMILY
    this["font-size"] = FONT_SIZE
    this["color"] = TEXT_COLOR
    this["line-height"] = "1"
    this["axf:ligature-mode"] = "all"
    this << Element.build("fo:layout-master-set") do |this|
      this << call(element, "section.page-master")
      this << call(element, "special.page-master")
      this << call(element, "part.page-master")
      this << call(element, "dummy.page-master")
    end
    this << apply(element, "")
  end
  next this
end

converter.add(["x", "xn"], [lambda{|s| !s.include?("sans")}]) do |element, scope, *args|
  this = Nodes[]
  this << Element.build("fo:inline") do |this|
    this["font-family"] = SHALEIA_FONT_FAMILY
    this["font-size"] = SHALEIA_FONT_SIZE
    this << apply(element, scope, *args)
  end
  next this
end

converter.add(["i"], [//]) do |element, scope, *args|
  this = Nodes[]
  this << Element.build("fo:inline") do |this|
    this["font-style"] = "italic"
    this << apply(element, scope, *args)
  end
  next this
end

converter.add_default(nil) do |text|
  this = Nodes[]
  this << ~text.to_s
  next this
end
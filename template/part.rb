# coding: utf-8


converter.set("part.page-master") do |element|
  this = Nodes[]
  this << Element.build_page_master do |this|
    this["master-name"] = "part.left"
    this << Element.build_region_body(:left) do |this|
      this["region-name"] = "part.dummy"
    end
    this << Element.build_region_after do |this|
      this["region-name"] = "part.left-footer"
    end
  end
  this << Element.build_page_master do |this|
    this["master-name"] = "part.right"
    this["background-color"] = BACKGROUND_COLOR
    this << Element.build_region_body(:right) do |this|
      this["region-name"] = "part.body"
    end
    this << Element.build_region_before do |this|
      this["region-name"] = "part.right-header"
    end
    this << Element.build_region_after do |this|
      this["region-name"] = "part.right-footer"
    end
  end
  this << Element.build("fo:page-sequence-master") do |this|
    this["master-name"] = "part"
    this << Element.build("fo:repeatable-page-master-alternatives") do |this|
      this << Element.build("fo:conditional-page-master-reference") do |this|
        this["master-reference"] = "part.left"
        this["odd-or-even"] = "even"
      end
      this << Element.build("fo:conditional-page-master-reference") do |this|
        this["master-reference"] = "part.right"
        this["odd-or-even"] = "odd"
      end
    end
  end
  next this
end

converter.add(["part"], [""]) do |element|
  this = Nodes[]
  this << Element.build("fo:page-sequence") do |this|
    this["master-reference"] = "part"
    this["initial-page-number"] = "auto-even"
    this << Element.build("fo:static-content") do |this|
      this["flow-name"] = "part.right-header"
    end
    this << Element.build("fo:static-content") do |this|
      this["flow-name"] = "part.left-footer"
    end
    this << Element.build("fo:static-content") do |this|
      this["flow-name"] = "part.right-footer"
    end
    this << Element.build("fo:flow") do |this|
      this["flow-name"] = "part.body"
      this << Element.build("fo:block-container") do |this|
        this << call(element, "part.number")
      end
    end
  end
  next this
end

converter.variables[:part_number] = 0

converter.define_singleton_method(:set_part_number) do
  converter.variables[:part_number] += 1
end

converter.define_singleton_method(:get_part_number) do
  next converter.variables[:part_number]
end

converter.set("part.number") do |element|
  this = Nodes[]
  set_part_number
  first_word = element.each_xpath("following::word[1]").first
  last_word = element.each_xpath("following-sibling::part[1]/preceding::word[1]").first || element.each_xpath("following::word[last()]").first
  this << Element.build("fo:block-container") do |this|
    this["top"] = "15mm"
    this["right"] = "-24mm"
    this["width"] = "60mm"
    this["height"] = "60mm"
    this["font-family"] = SPECIAL_FONT_FAMILY
    this["font-size"] = "14em"
    this["color"] = "white"
    this["text-align"] = "center"
    this["display-align"] = "center"
    this["axf:border-radius"] = "60mm"
    this["background-color"] = BORDER_COLOR
    this["absolute-position"] = "absolute"
    this << Element.build("fo:block") do |this|
      this.fix_text_position
      this << ~get_part_number.to_s
    end
  end
  this << Element.build("fo:block-container") do |this|
    this["top"] = "28mm"
    this["right"] = "37mm"
    this["font-family"] = SHALEIA_FONT_FAMILY
    this["font-size"] = "3em"
    this["font-weight"] = "bold"
    this["color"] = BORDER_COLOR
    this["text-align"] = "right"
    this["absolute-position"] = "absolute"
    this << Element.build("fo:block") do |this|
      this << ~"tôlak"
    end
  end
  this << Element.build("fo:block-container") do |this|
    this["top"] = "28mm"
    this["right"] = "18mm"
    this["font-family"] = SHALEIA_FONT_FAMILY
    this["font-size"] = "3em"
    this["font-weight"] = "bold"
    this["color"] = "white"
    this["text-align"] = "right"
    this["absolute-position"] = "absolute"
    this << Element.build("fo:block") do |this|
      this << ~"ac'"
    end
  end
  this << Element.build("fo:block-container") do |this|
    this["top"] = "80mm"
    this["right"] = "0mm"
    this["text-align"] = "right"
    this["absolute-position"] = "absolute"
    this << Element.build("fo:block") do |this|
      this["font-size"] = "3em"
      this << Element.build("fo:inline") do |this|
        this["font-family"] = SPECIAL_FONT_FAMILY
        this.fix_text_position
        this << ~get_word_number(first_word.attribute("id").to_s).to_s
      end
      this << Element.build("fo:inline") do |this|
        this["margin-left"] = "0.3em"
        this["margin-right"] = "0.3em"
        this["color"] = BORDER_COLOR
        this << ~"▶"
      end
      this << Element.build("fo:inline") do |this|
        this["font-family"] = SPECIAL_FONT_FAMILY
        this.fix_text_position
        this << ~get_word_number(last_word.attribute("id").to_s).to_s
      end
    end
  end
  next this
end
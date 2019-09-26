# coding: utf-8


SPECIAL_BOX_VERTICAL_PADDING = "2mm"
SPECIAL_BOX_HORIZONTAL_PADDING = "3mm"

converter.set("special.page-master") do |element|
  this = Nodes[]
  this << Element.build_page_master do |this|
    this["master-name"] = "special.left"
    this << Element.build_region_body(:left) do |this|
      this["region-name"] = "special.body"
    end
    this << Element.build_region_before do |this|
      this["region-name"] = "special.header"
    end
    this << Element.build_region_after do |this|
      this["region-name"] = "special.left-footer"
    end
    this << Element.build_region_start(:left) do |this|
      this["region-name"] = "special.left-side"
    end
  end
  this << Element.build_page_master do |this|
    this["master-name"] = "special.right"
    this << Element.build_region_body(:right) do |this|
      this["region-name"] = "special.body"
    end
    this << Element.build_region_before do |this|
      this["region-name"] = "special.header"
    end
    this << Element.build_region_after do |this|
      this["region-name"] = "special.right-footer"
    end
    this << Element.build_region_end(:right) do |this|
      this["region-name"] = "special.right-side"
    end
  end
  this << Element.build("fo:page-sequence-master") do |this|
    this["master-name"] = "special"
    this << Element.build("fo:repeatable-page-master-alternatives") do |this|
      this << Element.build("fo:conditional-page-master-reference") do |this|
        this["master-reference"] = "special.left"
        this["odd-or-even"] = "even"
      end
      this << Element.build("fo:conditional-page-master-reference") do |this|
        this["master-reference"] = "special.right"
        this["odd-or-even"] = "odd"
      end
    end
  end
  next this
end

converter.add(["special"], [""]) do |element|
  this = Nodes[]
  this << Element.build("fo:page-sequence") do |this|
    this["master-reference"] = "special"
    this["initial-page-number"] = "auto-even"
    this << Element.build("fo:static-content") do |this|
      this["flow-name"] = "special.header"
    end
    this << Element.build("fo:static-content") do |this|
      this["flow-name"] = "special.left-footer"
      this << call(element, "page-number", :left)
    end
    this << Element.build("fo:static-content") do |this|
      this["flow-name"] = "special.right-footer"
      this << call(element, "page-number", :right)
    end
    this << Element.build("fo:static-content") do |this|
      this["flow-name"] = "special.left-side"
      this << call(element, "section.side", :left, :full_single)
    end
    this << Element.build("fo:static-content") do |this|
      this["flow-name"] = "special.right-side"
      this << call(element, "section.side", :right, :full_single)
    end
    this << Element.build("fo:flow") do |this|
      this["flow-name"] = "special.body"
      this << Element.build("fo:block-container") do |this|
        this << apply(element, "special")
      end
    end
  end
  next this
end

converter.add(["word"], ["special"]) do |element|
  this = Nodes[]
  set_word_element(element)
  set_word_number(element)
  id = element.attribute("id").to_s
  this << Element.build("fo:block") do |this|
    this["id"] = "word-#{id}"
    this["space-before"] = "-1 * (#{PAGE_TOP_SPACE} + #{BLEED_SIZE})"
    this["space-before.precedence"] = "force"
    this["space-before.conditionality"] = "retain"
    this["break-after"] = "page"
    this << Element.build("fo:marker") do |this|
      this["marker-class-name"] = "word"
      this << ~get_word_number(id).to_s
    end
    this << call(element, "special.word-table")
    this << call(element, "section.word-checkbox", :bottom, 1)
    this << Element.build("fo:block") do |this|
      this["space-before"] = "6mm"
      this << apply_select(element, "dt", "special.word")
    end
  end
  next this
end

converter.set("special.word-table") do |element|
  this = Nodes[]
  this << Element.build("fo:block") do |this|
    this["border-width"] = BORDER_WIDTH
    this["border-top-width"] = "0mm"
    this["border-color"] = BORDER_COLOR
    this["border-style"] = "solid"
    this["axf:border-bottom-right-radius"] = BORDER_RADIUS
    this << Element.build("fo:block") do |this|
      this["margin-left"] = "0mm"
      this["margin-right"] = "0mm"
      this["padding-top"] = "#{PAGE_TOP_SPACE} + #{BLEED_SIZE}"
      this["padding-bottom"] = "#{SPECIAL_BOX_VERTICAL_PADDING} + 1mm"
      this["padding-left"] = SPECIAL_BOX_HORIZONTAL_PADDING
      this["padding-right"] = SPECIAL_BOX_HORIZONTAL_PADDING
      this["background-color"] = BACKGROUND_COLOR
      this << apply_select(element, "n", "special.word")
    end
    this << Element.build("fo:block") do |this|
      this["margin-left"] = "0mm"
      this["margin-right"] = "0mm"
      this["padding-top"] = SPECIAL_BOX_VERTICAL_PADDING
      this["padding-bottom"] = SPECIAL_BOX_VERTICAL_PADDING
      this["padding-left"] = SPECIAL_BOX_HORIZONTAL_PADDING
      this["padding-right"] = SPECIAL_BOX_HORIZONTAL_PADDING
      this << apply_select(element, "eq", "special.word")
    end
  end
  next this
end

converter.add(["n"], ["special.word"]) do |element|
  this = Nodes[]
  this << Element.build("fo:block") do |this|
    this << Element.build("fo:inline") do |this|
      this["margin-right"] = "0.5em"
      this["font-size"] = "5em"
      this << apply(element, "special.word")
    end
    this << Element.build("fo:inline") do |this|
      this["font-size"] = "1.5em"
      this["line-height"] = LINE_HEIGHT
      this << Element.build("fo:inline") do |this|
        this["margin-right"] = "0.5em"
        this << apply(element, "special.word.sans")
      end
      this << Element.build("fo:inline") do |this|
        this << ~"/#{Shaleian.pronunciation(element.inner_text)}/"
      end
    end
  end
  next this
end

converter.add(["eq"], ["special.word"]) do |element|
  this = Nodes[]
  this << Element.build("fo:block") do |this|
    this["font-size"] = "1.2em"
    this["color"] = RED_TEXT_COLOR
    this["line-height"] = LINE_HEIGHT
    this << call(element, "section.word.category")
    this << apply(element, "special.word.eq")
  end
  next this
end

converter.add(["dt"], ["special.word"]) do |element|
  this = Nodes[]
  this << Element.build("fo:block") do |this|
    this << apply(element, "special.word.dt")
  end
  next this
end

converter.add(["p"], ["special.word.dt"]) do |element|
  this = Nodes[]
  this << Element.build("fo:block") do |this|
    this["space-before"] = SECTION_PARAGRAPH_SPACE
    this["space-after"] = SECTION_PARAGRAPH_SPACE
    this["line-height"] = LINE_HEIGHT
    this.justify_text
    this << apply(element, "special.word.dt.p")
  end
  next this
end

converter.add(["xl"], ["special.word.dt"]) do |element|
  this = Nodes[]
  this << Element.build("fo:block") do |this|
    this["space-before"] = SECTION_PARAGRAPH_SPACE
    this["space-after"] = SECTION_PARAGRAPH_SPACE
    this["line-height"] = LINE_HEIGHT
    this.justify_text
    this << Element.build("fo:list-block") do |this|
      this["provisional-distance-between-starts"] = "0.9em"
      this["provisional-label-separation"] = "0.4em"
      this << apply(element, "special.word.dt.xl")
    end
  end 
  next this
end
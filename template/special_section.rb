# coding: utf-8


converter.set("special-section.page-master") do |element|
  this = Nodes[]
  this << Element.build_page_master do |this|
    this["master-name"] = "special-section.left"
    this << Element.build_region_body(:left) do |this|
      this["region-name"] = "special-section.body"
    end
    this << Element.build_region_before do |this|
      this["region-name"] = "special-section.header"
    end
    this << Element.build_region_after do |this|
      this["region-name"] = "special-section.left-footer"
    end
    this << Element.build_region_start(:left) do |this|
      this["region-name"] = "special-section.left-side"
    end
  end
  this << Element.build_page_master do |this|
    this["master-name"] = "special-section.right"
    this << Element.build_region_body(:right) do |this|
      this["region-name"] = "special-section.body"
    end
    this << Element.build_region_before do |this|
      this["region-name"] = "special-section.header"
    end
    this << Element.build_region_after do |this|
      this["region-name"] = "special-section.right-footer"
    end
    this << Element.build_region_end(:right) do |this|
      this["region-name"] = "special-section.right-side"
    end
  end
  this << Element.build("fo:page-sequence-master") do |this|
    this["master-name"] = "special-section"
    this << Element.build("fo:repeatable-page-master-alternatives") do |this|
      this << Element.build("fo:conditional-page-master-reference") do |this|
        this["master-reference"] = "special-section.left"
        this["odd-or-even"] = "even"
      end
      this << Element.build("fo:conditional-page-master-reference") do |this|
        this["master-reference"] = "special-section.right"
        this["odd-or-even"] = "odd"
      end
    end
  end
  next this
end

converter.add(["special-section"], [""]) do |element|
  this = Nodes[]
  this << Element.build("fo:page-sequence") do |this|
    this["master-reference"] = "special-section"
    this["initial-page-number"] = "auto-even"
    this << Element.build("fo:static-content") do |this|
      this["flow-name"] = "special-section.header"
    end
    this << Element.build("fo:static-content") do |this|
      this["flow-name"] = "special-section.left-footer"
      this << call(element, "page-number", :left)
    end
    this << Element.build("fo:static-content") do |this|
      this["flow-name"] = "special-section.right-footer"
      this << call(element, "page-number", :right)
    end
    this << Element.build("fo:static-content") do |this|
      this["flow-name"] = "special-section.left-side"
      this << call(element, "section.side", :left, :full_single)
    end
    this << Element.build("fo:static-content") do |this|
      this["flow-name"] = "special-section.right-side"
      this << call(element, "section.side", :right, :full_single)
    end
    this << Element.build("fo:flow") do |this|
      this["flow-name"] = "special-section.body"
      this << Element.build("fo:block-container") do |this|
        this << apply(element, "special-section")
      end
    end
  end
  next this
end

converter.add(["word"], ["special-section"]) do |element|
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
    this << call(element, "special-section.word-table")
  end
  next this
end

converter.set("special-section.word-table") do |element|
  this = Nodes[]
  this << Element.build("fo:block") do |this|
    this["border-width"] = BORDER_WIDTH
    this["border-top-width"] = "0mm"
    this["border-color"] = BORDER_COLOR
    this["border-style"] = "solid"
    this["axf:border-radius"] = BORDER_RADIUS
    this["axf:border-top-left-radius"] = "0mm"
    this["axf:border-top-right-radius"] = "0mm"
    this << apply_select(element, "n", "special-section.word")
    this << apply_select(element, "eq", "special-section.word")
  end
  next this
end

converter.add(["n"], ["special-section.word"]) do |element|
  this = Nodes[]
  this << Element.build("fo:block") do |this|
    this["margin-left"] = "0mm"
    this["margin-right"] = "0mm"
    this["padding-top"] = "#{PAGE_TOP_SPACE} + #{BLEED_SIZE}"
    this["padding-bottom"] = "1.5mm"
    this["padding-left"] = "2.5mm"
    this["padding-right"] = "2.5mm"
    this["background-color"] = BACKGROUND_COLOR
    this << Element.build("fo:block") do |this|
      this["font-size"] = "5em"
      this << apply(element, "special-section.word")
    end
    this << Element.build("fo:block") do |this|
      this["space-before"] = "0.5mm"
      this["font-size"] = "0.8em"
      this << Element.build("fo:inline") do |this|
        this["margin-right"] = "0.5em"
        this << apply(element, "special-section.word.sans")
      end
      this << Element.build("fo:inline") do |this|
        this << ~"/#{Shaleian.pronunciation(element.inner_text)}/"
      end
    end
  end
  next this
end

converter.add(["eq"], ["special-section.word"]) do |element|
  this = Nodes[]
  this << Element.build("fo:block") do |this|
    this["margin-left"] = "0mm"
    this["margin-right"] = "0mm"
    this["padding-top"] = "1.5mm"
    this["padding-bottom"] = "1.5mm"
    this["padding-left"] = "2.5mm"
    this["padding-right"] = "2.5mm"
    this["color"] = RED_TEXT_COLOR
    this["line-height"] = LINE_HEIGHT
    this << call(element, "section.word.category")
    this << apply(element, "special-section.word.eq")
  end
  next this
end
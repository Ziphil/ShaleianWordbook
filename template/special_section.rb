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
  id = element.attribute("id").to_s
  set_word_element(element)
  this << Element.build("fo:block") do |this|
    this["id"] = "word-#{id}"
    this["space-before"] = "4mm"
    this["space-after"] = "4mm"
    this.make_elastic("space-before")
    this.make_elastic("space-after")
    this["keep-together.within-page"] = "always"
    this["break-after"] = "page"
    this << call(element, "section.word-checkbox")
    this << call(element, "special-section.word-table")
  end
  next this
end

converter.set("special-section.word-table") do |element|
  this = Nodes[]
  this << Element.build("fo:table-and-caption") do |this|
    this << Element.build("fo:table") do |this|
      this["table-layout"] = "fixed"
      this["border-width"] = BORDER_WIDTH
      this["border-color"] = BORDER_COLOR
      this["border-style"] = "solid"
      this["axf:border-radius"] = "1mm"
      this["axf:border-top-left-radius"] = "0mm"
      this << Element.build("fo:table-column") do |this|
        this["column-number"] = "1"
        this["column-width"] = NAME_WIDTH
      end
      this << Element.build("fo:table-column") do |this|
        this["column-number"] = "2"
        this["column-width"] = "#{PAGE_WIDTH} - #{PAGE_INNER_SPACE} - #{PAGE_OUTER_SPACE} - #{NAME_WIDTH}"
      end
      this << Element.build("fo:table-body") do |this|
        this << Element.build("fo:table-row") do |this|
          this << Element.build("fo:table-cell") do |this|
            this["padding-top"] = "1.5mm"
            this["padding-bottom"] = "1.5mm"
            this["padding-left"] = "2.5mm"
            this["padding-right"] = "2.5mm"
            this["background-color"] = BACKGROUND_COLOR
            this << apply_select(element, "n", "special-section.word")
          end
          this << Element.build("fo:table-cell") do |this|
            this["padding-top"] = "1.5mm"
            this["padding-bottom"] = "1.5mm"
            this["padding-left"] = "2.5mm"
            this["padding-right"] = "0mm"
            this << apply_select(element, "eq", "special-section.word")
          end
        end
      end
    end
  end
  next this
end

converter.add(["n"], ["special-section.word"]) do |element|
  this = Nodes[]
  this << Element.build("fo:block") do |this|
    this["font-size"] = "1.5em"
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
  next this
end

converter.add(["eq"], ["special-section.word"]) do |element|
  this = Nodes[]
  this << Element.build("fo:block") do |this|
    this["color"] = RED_TEXT_COLOR
    this["line-height"] = LINE_HEIGHT
    this << Element.build("fo:inline-container") do |this|
      this["margin-right"] = "0.5em"
      this["padding-top"] = "0.1em"
      this["padding-bottom"] = "0.1em"
      this["padding-left"] = "0.2em"
      this["padding-right"] = "0.2em"
      this["font-size"] = "0.8em"
      this["color"] = "white"
      this["line-height"] = "1"
      this["background-color"] = CATEGORY_BACKGROUND_COLOR
      this["axf:border-radius"] = "0.5mm"
      this << Element.build("fo:block") do |this|
        this << ~element.attribute("cat").to_s
      end
    end
    this << apply(element, "special-section.word.eq")
  end
  next this
end
# coding: utf-8


SPECIAL_SECTION_BOX_VERTICAL_PADDING = "2mm"
SPECIAL_SECTION_BOX_HORIZONTAL_PADDING = "3mm"

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
    this << call(element, "section.word-checkbox", :bottom, 1)
    this << Element.build("fo:block") do |this|
      this["space-before"] = "6mm"
      this << apply_select(element, "*[name(.) = 'us' or name(.) = 'ex']", "special-section.word")
    end
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
    this["axf:border-bottom-right-radius"] = BORDER_RADIUS
    this << Element.build("fo:block") do |this|
      this["margin-left"] = "0mm"
      this["margin-right"] = "0mm"
      this["padding-top"] = "#{PAGE_TOP_SPACE} + #{BLEED_SIZE}"
      this["padding-bottom"] = "#{SPECIAL_SECTION_BOX_VERTICAL_PADDING} + 1mm"
      this["padding-left"] = SPECIAL_SECTION_BOX_HORIZONTAL_PADDING
      this["padding-right"] = SPECIAL_SECTION_BOX_HORIZONTAL_PADDING
      this["background-color"] = BACKGROUND_COLOR
      this << apply_select(element, "n", "special-section.word")
    end
    this << Element.build("fo:block") do |this|
      this["margin-left"] = "0mm"
      this["margin-right"] = "0mm"
      this["padding-top"] = SPECIAL_SECTION_BOX_VERTICAL_PADDING
      this["padding-bottom"] = SPECIAL_SECTION_BOX_VERTICAL_PADDING
      this["padding-left"] = SPECIAL_SECTION_BOX_HORIZONTAL_PADDING
      this["padding-right"] = SPECIAL_SECTION_BOX_HORIZONTAL_PADDING
      this << apply_select(element, "eq", "special-section.word")
    end
  end
  next this
end

converter.add(["n"], ["special-section.word"]) do |element|
  this = Nodes[]
  this << Element.build("fo:block") do |this|
    this << Element.build("fo:inline") do |this|
      this["margin-right"] = "0.5em"
      this["font-size"] = "5em"
      this << apply(element, "special-section.word")
    end
    this << Element.build("fo:inline") do |this|
      this["font-size"] = "1.5em"
      this["line-height"] = LINE_HEIGHT
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
    this["font-size"] = "1.2em"
    this["color"] = RED_TEXT_COLOR
    this["line-height"] = LINE_HEIGHT
    this << call(element, "section.word.category")
    this << apply(element, "special-section.word.eq")
  end
  next this
end

converter.add(["us"], ["special-section.word"]) do |element|
  this = Nodes[]
  this << Element.build("fo:block") do |this|
    this["space-before"] = SECTION_PARAGRAPH_SPACE
    this["line-height"] = LINE_HEIGHT
    this.justify_text
    this << apply(element, "special-section.word.us")
  end
  next this
end

converter.add(["ex"], ["special-section.word"]) do |element|
  this = Nodes[]
  this << Element.build("fo:block") do |this|
    this["space-before"] = SECTION_PARAGRAPH_SPACE
    this["line-height"] = LINE_HEIGHT
    this.justify_text
    this << Element.build("fo:list-block") do |this|
      this["provisional-distance-between-starts"] = "0.9em"
      this["provisional-label-separation"] = "0.4em"
      this << Element.build("fo:list-item") do |this|
        this << Element.build("fo:list-item-label") do |this|
          this["start-indent"] = "0em"
          this["end-indent"] = "label-end()"
          this["color"] = CATEGORY_BACKGROUND_COLOR
          this << Element.build("fo:block") do |this|
            this << ~"▶"
          end
        end
        this << Element.build("fo:list-item-body") do |this|
          this["start-indent"] = "body-start()"
          this << Element.build("fo:block") do |this|
            this["font-size"] = "1.2em"
            this << apply_select(element, "sh", "special-section.word.ex")
          end
          this << Element.build("fo:block") do |this|
            this["start-indent"] = "body-start() + 1em"
            this["font-size"] = "1em"
            this << apply_select(element, "ja", "special-section.word.ex")
          end
        end
      end
    end
  end 
  next this
end

converter.add(["sh"], ["special-section.word.ex"]) do |element|
  this = Nodes[]
  this << apply(element, "special-section.word.ex")
  next this
end

converter.add(["ja"], ["special-section.word.ex"]) do |element|
  this = Nodes[]
  this << apply(element, "special-section.word.ex")
  next this
end
# coding: utf-8


NAME_WIDTH = "25mm"
EXAMPLE_WIDTH = "45mm"

CATEGORY_BACKGROUND_COLOR = "hsl(0, 0%, 50%)"

converter.set("section.page-master") do |element|
  this = Nodes[]
  this << Element.build_page_master do |this|
    this["master-name"] = "section.left"
    this << Element.build_region_body(:left) do |this|
      this["region-name"] = "section.body"
    end
    this << Element.build_region_before do |this|
      this["region-name"] = "section.header"
    end
    this << Element.build_region_after do |this|
      this["region-name"] = "section.left-footer"
    end
  end
  this << Element.build_page_master do |this|
    this["master-name"] = "section.right"
    this << Element.build_region_body(:right) do |this|
      this["region-name"] = "section.body"
    end
    this << Element.build_region_before do |this|
      this["region-name"] = "section.header"
    end
    this << Element.build_region_after do |this|
      this["region-name"] = "section.right-footer"
    end
  end
  this << Element.build_spread_page_master do |this|
    this["master-name"] = "section.spread"
    this["left-page-master-reference"] = "section.left"
    this["right-page-master-reference"] = "section.right"
    this << Element.build_spread_region do |this|
      this["region-name"] = "section.spread-body"
    end
  end
  this << Element.build("fo:page-sequence-master") do |this|
    this["master-name"] = "section"
    this << Element.build("fo:repeatable-page-master-reference") do |this|
      this["master-reference"] = "section.spread"
    end
    this << Element.build("fo:repeatable-page-master-alternatives") do |this|
      this << Element.build("fo:conditional-page-master-reference") do |this|
        this["master-reference"] = "section.left"
        this["odd-or-even"] = "even"
      end
      this << Element.build("fo:conditional-page-master-reference") do |this|
        this["master-reference"] = "section.right"
        this["odd-or-even"] = "odd"
      end
    end
  end
  next this
end

converter.add(["section"], [""]) do |element|
  this = Nodes[]
  this << Element.build("fo:page-sequence") do |this|
    this["master-reference"] = "section"
    this["initial-page-number"] = "auto-even"
    this << Element.build("fo:static-content") do |this|
      this["flow-name"] = "section.header"
    end
    this << Element.build("fo:static-content") do |this|
      this["flow-name"] = "section.left-footer"
      this << call(element, "page-number", :left)
    end
    this << Element.build("fo:static-content") do |this|
      this["flow-name"] = "section.right-footer"
      this << call(element, "page-number", :right)
    end
    this << Element.build("fo:flow") do |this|
      this["flow-name"] = "section.spread-body"
      this << Element.build("fo:block-container") do |this|
        this << apply(element, "section")
      end
    end
    this << Element.build("fo:flow") do |this|
      this["flow-name"] = "section.body"
      this << Element.new("fo:block")
    end
  end
  next this
end

converter.add(["word"], ["section"]) do |element|
  this = Nodes[]
  number = element.each_xpath("preceding-sibling::word").to_a.size + 1
  this << Element.build("fo:block") do |this|
    this["space-before"] = "5mm"
    this["space-after"] = "5mm"
    this.make_elastic("space-before")
    this.make_elastic("space-after")
    this["keep-together.within-page"] = "always"
    this << Element.build("fo:block") do |this|
      this["margin-left"] = "0.5em"
      this["font-family"] = SPECIAL_FONT_FAMILY
      this["font-size"] = "0.9em"
      this << ~number.to_s
    end
    this << Element.build("fo:table-and-caption") do |this|
      this << Element.build("fo:table") do |this|
        this["table-layout"] = "fixed"
        this["border-width"] = BORDER_WIDTH
        this["border-color"] = BORDER_COLOR
        this["border-style"] = "solid"
        this["axf:border-radius"] = "1mm"
        this << Element.build("fo:table-column") do |this|
          this["column-number"] = "1"
          this["column-width"] = NAME_WIDTH
        end
        this << Element.build("fo:table-column") do |this|
          this["column-number"] = "2"
          this["column-width"] = "#{PAGE_WIDTH} - #{PAGE_INNER_SPACE} - #{PAGE_OUTER_SPACE} - #{NAME_WIDTH}"
        end
        this << Element.build("fo:table-column") do |this|
          this["column-number"] = "3"
          this["column-width"] = "#{PAGE_INNER_SPACE} * 2"
        end
        this << Element.build("fo:table-column") do |this|
          this["column-number"] = "4"
          this["column-width"] = "#{PAGE_WIDTH} - #{PAGE_INNER_SPACE} - #{PAGE_OUTER_SPACE}"
        end
        this << Element.build("fo:table-body") do |this|
          this << Element.build("fo:table-row") do |this|
            this << Element.build("fo:table-cell") do |this|
              this["padding-top"] = "1.5mm"
              this["padding-bottom"] = "1.5mm"
              this["padding-left"] = "2.5mm"
              this["padding-right"] = "2.5mm"
              this["background-color"] = BACKGROUND_COLOR
              this << apply_select(element, "n", "section.word")
            end
            this << Element.build("fo:table-cell") do |this|
              this["padding-top"] = "1.5mm"
              this["padding-bottom"] = "1.5mm"
              this["padding-left"] = "2.5mm"
              this["padding-right"] = "0mm"
              this << apply_select(element, "eq", "section.word")
              this << apply_select(element, "us", "section.word")
            end
            this << Element.new("fo:table-cell")
            this << Element.build("fo:table-cell") do |this|
              this["padding-top"] = "1.5mm"
              this["padding-bottom"] = "1.5mm"
              this["padding-left"] = "0mm"
              this["padding-right"] = "0mm"
              this << apply_select(element, "ex", "section.word")
            end
          end
        end
      end
    end
  end
  next this
end

converter.add(["n"], ["section.word"]) do |element|
  this = Nodes[]
  this << Element.build("fo:block") do |this|
    this["font-size"] = "1.5em"
    this << apply(element, "section.word")
  end
  this << Element.build("fo:block") do |this|
    this["space-before"] = "0.5mm"
    this["font-size"] = "0.8em"
    this << Element.build("fo:inline") do |this|
      this["margin-right"] = "0.5em"
      this << apply(element, "section.word.sans")
    end
    this << Element.build("fo:inline") do |this|
      this << ~"/#{Shaleian.pronunciation(element.inner_text)}/"
    end
  end
  next this
end

converter.add(["x", "xn"], ["section.word.sans"]) do |element, scope, *args|
  this = Nodes[]
  this << Element.build("fo:inline") do |this|
    this["font-family"] = SANS_FONT_FAMILY
    this["font-size"] = SANS_FONT_SIZE
    this << apply(element, scope, *args)
  end
  next this
end

converter.add(["eq"], ["section.word"]) do |element|
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
    this << apply(element, "section.word.eq")
  end
  next this
end

converter.add(["s"], ["section.word.eq"]) do |element|
  this = Nodes[]
  this << Element.build("fo:inline") do |this|
    this["margin-right"] = "0.3em"
    this["font-size"] = "0.9em"
    this << apply(element, "section.word.eq")
  end
  next this
end

converter.add(["us"], ["section.word"]) do |element|
  this = Nodes[]
  this << Element.build("fo:block") do |this|
    this["space-before"] = "0.2em"
    this["font-size"] = "0.9em"
    this["line-height"] = LINE_HEIGHT
    this["text-align"] = "justify"
    this["axf:text-justify-trim"] = "punctuation ideograph inter-word"
    this << apply(element, "section.word.us")
  end
  next this
end

converter.add(["l"], ["section.word.us"]) do |element|
  this = Nodes[]
  this << Element.build("fo:inline") do |this|
    this << apply(element, "section.word.us")
  end
  next this
end

converter.add(["ex"], ["section.word"]) do |element|
  this = Nodes[]
  this << Element.build("fo:block") do |this|
    this["space-before"] = "0.2em"
    this["line-height"] = LINE_HEIGHT
    this["text-align"] = "justify"
    this["axf:text-justify-trim"] = "punctuation ideograph inter-word"
    this << Element.build("fo:block") do |this|
      this << apply_select(element, "sh", "section.word.ex")
    end
    this << Element.build("fo:block") do |this|
      this["start-indent"] = "1em"
      this["font-size"] = "0.9em"
      this << apply_select(element, "ja", "section.word.ex")
    end
  end 
  next this
end

converter.add(["sh"], ["section.word.ex"]) do |element|
  this = Nodes[]
  this << apply(element, "section.word.ex")
  next this
end

converter.add(["ja"], ["section.word.ex"]) do |element|
  this = Nodes[]
  this << apply(element, "section.word.ex")
  next this
end

converter.add(["b"], ["section.word.ex"]) do |element|
  this = Nodes[]
  this << Element.build("fo:inline") do |this|
    this["color"] = RED_TEXT_COLOR
    this["border-bottom-width"] = TEXT_BORDER_WIDTH
    this["border-bottom-color"] = TEXT_COLOR
    this["border-bottom-style"] = "solid"
    this << apply(element, "section.word.eq")
  end
  next this
end

converter.add(nil, [/section\.word(.*)/]) do |text|
  this = Nodes[]
  this << ~text.to_s.gsub(/(?<=。)\s*\n\s*/, "")
  next this
end
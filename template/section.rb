# coding: utf-8


NAME_WIDTH = "25mm"
EXAMPLE_WIDTH = "45mm"

CATEGORY_BACKGROUND_COLOR = "rgb-icc(#CMYK, 0, 0, 0, 0.6)"

converter.set("section.page-master") do |element|
  this = Nodes[]
  this << Element.build_page_master do |this|
    this["master-name"] = "section.left"
    this << Element.build_region_body(:left) do |this|
      this["region-name"] = "section.body"
    end
    this << Element.build_region_before do |this|
      this["region-name"] = "section.left-header"
    end
    this << Element.build_region_after do |this|
      this["region-name"] = "section.left-footer"
    end
    this << Element.build_region_start(:left) do |this|
      this["region-name"] = "section.left-side"
    end
  end
  this << Element.build_page_master do |this|
    this["master-name"] = "section.right"
    this << Element.build_region_body(:right) do |this|
      this["region-name"] = "section.body"
    end
    this << Element.build_region_before do |this|
      this["region-name"] = "section.right-header"
    end
    this << Element.build_region_after do |this|
      this["region-name"] = "section.right-footer"
    end
    this << Element.build_region_end(:right) do |this|
      this["region-name"] = "section.right-side"
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
      this["flow-name"] = "section.left-header"
    end
    this << Element.build("fo:static-content") do |this|
      this["flow-name"] = "section.right-header"
    end
    this << Element.build("fo:static-content") do |this|
      this["flow-name"] = "section.left-footer"
      this << call(element, "page-number", :left)
    end
    this << Element.build("fo:static-content") do |this|
      this["flow-name"] = "section.right-footer"
      this << call(element, "page-number", :right)
    end
    this << Element.build("fo:static-content") do |this|
      this["flow-name"] = "section.left-side"
      this << call(element, "section.side", :left)
    end
    this << Element.build("fo:static-content") do |this|
      this["flow-name"] = "section.right-side"
      this << call(element, "section.side", :right)
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

converter.set("section.side") do |element, position|
  this = Nodes[]
  this << Element.build("fo:block-container") do |this|
    this["width"] = "#{PAGE_OUTER_SPACE} + #{BLEED_SIZE}"
    this["height"] = "#{PAGE_HEIGHT} - #{PAGE_TOP_SPACE} - #{PAGE_TOP_SPACE}"
    if position == :left
      this["margin-left"] = "-1 * #{BLEED_SIZE}"
    else
      this["margin-right"] = "-1 * #{BLEED_SIZE}"
    end
    this << Element.build("fo:block-container") do |this|
      this["width"] = "6mm"
      if position == :left
        this["margin-left"] = "0mm"
        this["padding-left"] = "5mm"
      else
        this["margin-right"] = "0mm"
        this["padding-right"] = "5mm"
      end
      this["padding-top"] = "1mm"
      this["padding-bottom"] = "1mm"
      this["background-color"] = BORDER_COLOR
      this["border-bottom-width"] = "0mm"
      if position == :left
        this["border-left-width"] = "0mm"
      else
        this["border-right-width"] = "0mm"
      end
      this["border-width"] = BORDER_WIDTH
      this["border-color"] = BORDER_COLOR
      this["border-style"] = "solid"
      if position == :left
        this["axf:border-top-right-radius"] = "1mm"
      else
        this["axf:border-top-left-radius"] = "1mm"
      end
      this << Element.build("fo:block") do |this|
        this.reset_indent
        this["color"] = "white"
        this["text-align"] = "center"
        this << Element.build("fo:block") do |this|
          this["font-size"] = "0.8em"
          this << ~"第"
        end
        this << Element.build("fo:block") do |this|
          this["font-family"] = SPECIAL_FONT_FAMILY
          this["font-size"] = "1.5em"
          this.fix_text_position
          this << ~"2"
        end
        this << Element.build("fo:block") do |this|
          this["font-size"] = "0.8em"
          this << ~"章"
        end
      end
    end
    this << Element.build("fo:block-container") do |this|
      this["width"] = "6mm"
      if position == :left
        this["margin-left"] = "0mm"
        this["padding-left"] = "5mm"
      else
        this["margin-right"] = "0mm"
        this["padding-right"] = "5mm"
      end
      this["padding-top"] = "1mm"
      this["padding-bottom"] = "1mm"
      this["background-color"] = BACKGROUND_COLOR
      this["border-top-width"] = "0mm"
      if position == :left
        this["border-left-width"] = "0mm"
      else
        this["border-right-width"] = "0mm"
      end
      this["border-width"] = BORDER_WIDTH
      this["border-color"] = BORDER_COLOR
      this["border-style"] = "solid"
      if position == :left
        this["axf:border-bottom-right-radius"] = "1mm"
      else
        this["axf:border-bottom-left-radius"] = "1mm"
      end
      this << Element.build("fo:block") do |this|
        this.reset_indent
        this["font-family"] = SPECIAL_FONT_FAMILY
        this["font-size"] = "1em"
        this["text-align"] = "center"
        this << Element.build("fo:block") do |this|
          this.fix_text_position
          this << Element.build("fo:retrieve-marker") do |this|
            this["retrieve-class-name"] = "word"
            this["retrieve-position"] = "first-starting-within-page"
          end
        end
        this << Element.build("fo:block") do |this|
          this.fix_text_position
          this << Element.build("fo:retrieve-marker") do |this|
            this["retrieve-class-name"] = "word"
            this["retrieve-position"] = "last-starting-within-page"
          end
        end
      end
    end
  end
  next this
end

converter.variables[:number] = 0
converter.variables[:numbers] = {}
converter.variables[:word_elements] = {}

converter.define_singleton_method(:set_number) do |element|
  id = element.attribute("id").to_s
  converter.variables[:number] += 1
  converter.variables[:numbers][id] = converter.variables[:number]
end

converter.define_singleton_method(:get_number) do |id|
  numbers = converter.variables[:numbers]
  if numbers.key?(id)
    next numbers[id]
  else
    element = get_word_element(id)
    if element
      number = element.each_xpath("preceding::word").to_a.size + 1
      numbers[id] = number
      next number
    else
      next nil
    end
  end
end

converter.define_singleton_method(:set_word_element) do |element|
  id = element.attribute("id").to_s
  converter.variables[:word_elements][id] = element
end

converter.define_singleton_method(:get_word_element) do |id|
  word_elements = converter.variables[:word_elements]
  if word_elements.key?(id)
    next word_elements[id]
  else
    root = converter.document.root
    element = root.each_xpath("section/word[@id='#{id}']").first
    if element
      word_elements[id] = element
      next element
    else
      next nil
    end
  end
end

converter.add(["word"], ["section"]) do |element|
  this = Nodes[]
  set_number(element)
  set_word_element(element)
  id = element.attribute("id").to_s
  this << Element.build("fo:block") do |this|
    this["id"] = "word-#{id}"
    this["space-before"] = "4mm"
    this["space-after"] = "4mm"
    this.make_elastic("space-before")
    this.make_elastic("space-after")
    this["keep-together.within-page"] = "always"
    this << Element.build("fo:marker") do |this|
      this["marker-class-name"] = "word"
      this << ~get_number(id).to_s
    end
    this << call(element, "section.word-checkbox")
    this << call(element, "section.word-table")
  end
  next this
end

converter.set("section.word-checkbox") do |element|
  this = Nodes[]
  id = element.attribute("id").to_s
  this << Element.build("fo:block") do |this|
    this["margin-left"] = "-#{BORDER_WIDTH} * 0.5"
    this["font-size"] = "0mm"
    this["line-height"] = "1"
    3.times do |i|
      this << Element.build("fo:inline-container") do |this|
        this["width"] = "3mm"
        this["height"] = "3mm"
        this["border-top-width"] = BORDER_WIDTH
        this["border-bottom-width"] = "0mm"
        this["border-left-width"] = (i == 0) ? BORDER_WIDTH : "0mm"
        this["border-right-width"] = BORDER_WIDTH
        this["border-color"] = BORDER_COLOR
        this["border-style"] = "solid"
        this["alignment-baseline"] = "central"
      end
    end
    this << Element.build("fo:inline") do |this|
      this["margin-left"] = "0.4em"
      this["font-family"] = SPECIAL_FONT_FAMILY
      this["font-size"] = "1rem"
      this["line-height"] = "1"
      this["alignment-baseline"] = "central"
      this.fix_text_position
      this << ~get_number(id).to_s
    end
    next this
  end
end

converter.set("section.word-table") do |element|
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
            this["padding-right"] = "2.5mm"
            this << apply_select(element, "ex", "section.word")
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

converter.add(["x", "xn"], ["section.word.sans", "special-section.word.sans"]) do |element, scope, *args|
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

converter.add(["s"], ["section.word.eq", "special-section.word.eq"]) do |element|
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
    this.justify_text
    this << apply(element, "section.word.us")
  end
  next this
end

converter.add(["l"], ["section.word.us", "special-section.word.us"]) do |element|
  this = Nodes[]
  if element.attribute("id")
    id = element.attribute("id").to_s
    word = get_word_element(id)
    if word
      this << Element.build("fo:basic-link") do |this|
        this["internal-destination"] = "word-#{id}"
        this << Element.build("fo:inline") do |this|
          this["keep-together.within-line"] = "always"
          this << Element.build("fo:inline") do |this|
            this << apply(word.get_elements("n").first, "section.word.us")
          end
          this << Element.build("fo:inline") do |this|
            this["margin-left"] = "0.3em"
            this["font-size"] = "0.8em"
            this["color"] = CATEGORY_BACKGROUND_COLOR
            this << ~"("
            this << Element.build("fo:inline") do |this|
              this["margin-right"] = "0.1em"
              this << ~"▷"
            end
            this << Element.build("fo:inline") do |this|
              this["font-family"] = SPECIAL_FONT_FAMILY
              this << ~get_number(id).to_s
            end
            this << ~")"
          end
        end
      end
    end
  end
  next this
end

converter.add(["ex"], ["section.word"]) do |element|
  this = Nodes[]
  this << Element.build("fo:block") do |this|
    this["space-before"] = "0.2em"
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
            this << apply_select(element, "sh", "section.word.ex")
          end
          this << Element.build("fo:block") do |this|
            this["start-indent"] = "body-start() + 1em"
            this["font-size"] = "0.9em"
            this << apply_select(element, "ja", "section.word.ex")
          end
        end
      end
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
# coding: utf-8


NAME_WIDTH = "20mm"

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
        this << apply(element, "section.word-table")
      end
    end
    this << Element.build("fo:flow") do |this|
      this["flow-name"] = "section.body"
      this << Element.new("fo:block")
    end
  end
  next this
end

converter.add(["word"], ["section.word-table"]) do |element|
  this = Nodes[]
  this << Element.build("fo:block") do |this|
    this["space-before"] = "5mm"
    this["space-after"] = "5mm"
    this.make_elastic("space-before")
    this.make_elastic("space-after")
    this << Element.build("fo:table-and-caption") do |this|
      this << Element.build("fo:table") do |this|
        this["table-layout"] = "fixed"
        this["border-width"] = "0.2mm"
        this["border-color"] = BORDER_COLOR
        this["border-style"] = "solid"
        this["axf:border-radius"] = "1mm"
        this << Element.build("fo:table-column") do |this|
          this["column-number"] = "1"
          this["column-width"] = NAME_WIDTH
          this["background-color"] = BACKGROUND_COLOR
        end
        this << Element.build("fo:table-column") do |this|
          this["column-number"] = "2"
          this["column-width"] = "#{PAGE_WIDTH} - #{PAGE_INNER_SPACE} - #{PAGE_OUTER_SPACE} - #{NAME_WIDTH}"
        end
        this << Element.build("fo:table-column") do |this|
          this["column-number"] = "3"
          this["column-width"] = "#{PAGE_INNER_SPACE} + #{PAGE_OUTER_SPACE}"
        end
        this << Element.build("fo:table-column") do |this|
          this["column-number"] = "4"
          this["column-width"] = "#{PAGE_WIDTH} - #{PAGE_INNER_SPACE} - #{PAGE_OUTER_SPACE}"
        end
        this << Element.build("fo:table-body") do |this|
          this << Element.build("fo:table-row") do |this|
            this << Element.build("fo:table-cell") do |this|
              this << apply_select(element, "n", "section.word-table.word")
            end
            this << Element.build("fo:table-cell") do |this|
              this << apply_select(element, "eq | us", "section.word-table.word")
            end
            this << Element.new("fo:table-cell")
            this << Element.build("fo:table-cell") do |this|
              this << apply_select(element, "ex", "section.word-table.word")
            end
          end
        end
      end
    end
  end
  next this
end

converter.add(["n"], ["section.word-table.word"]) do |element|
  this = Nodes[]
  this << Element.build("fo:block") do |this|
    this << apply(element, "section.word-table.word")
  end
  next this
end

converter.add(["eq"], ["section.word-table.word"]) do |element|
  this = Nodes[]
  this << Element.build("fo:block") do |this|
    this << apply(element, "section.word-table.word")
  end
  next this
end

converter.add(["us"], ["section.word-table.word"]) do |element|
  this = Nodes[]
  this << Element.build("fo:block") do |this|
    this << apply(element, "section.word-table.word")
  end
  next this
end

converter.add(["ex"], ["section.word-table.word"]) do |element|
  this = Nodes[]
  this << Element.build("fo:block") do |this|
    this << apply(element, "section.word-table.word")
  end
  next this
end

converter.add(nil, ["section.word-table.word"]) do |text|
  this = Nodes[]
  this << ~text.to_s.gsub(/(?<=。)\s*\n\s*/, "")
  next this
end
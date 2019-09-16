# coding: utf-8


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
  this << Element.build("fo:page-sequence-master") do |this|
    this["master-name"] = "section"
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
      this["flow-name"] = "section.body"
      this << Element.build("fo:block") do |this|
        this << apply(element, "section")
      end
    end
  end
  next this
end

converter.add(["p"], ["section"]) do |element|
  this = Nodes[]
  this << Element.build("fo:block") do |this|
    this["space-before"] = "0mm"
    this["space-after"] = "0mm"
    this.make_elastic("space-before")
    this.make_elastic("space-after")
    this["line-height"] = LINE_HEIGHT
    this["text-align"] = "justify"
    this["axf:text-justify-trim"] = "punctuation ideograph inter-word"
    this["widows"] = "1"
    this["orphans"] = "1"
    this << apply(element, "section.content.p")
  end
  next this
end

converter.add(nil, ["section.p"]) do |text|
  this = Nodes[]
  this << ~text.to_s.gsub(/(?<=。)\s*\n\s*/, "")
  next this
end
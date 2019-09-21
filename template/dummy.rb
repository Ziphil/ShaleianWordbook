# coding: utf-8


converter.set("dummy.page-master") do |element|
  this = Nodes[]
  this << Element.build_page_master do |this|
    this["master-name"] = "dummy.left"
    this << Element.build_region_body(:left) do |this|
      this["region-name"] = "dummy.body"
    end
    this << Element.build_region_before do |this|
      this["region-name"] = "dummy.header"
    end
    this << Element.build_region_after do |this|
      this["region-name"] = "dummy.left-footer"
    end
  end
  this << Element.build_page_master do |this|
    this["master-name"] = "dummy.right"
    this << Element.build_region_body(:right) do |this|
      this["region-name"] = "dummy.body"
    end
    this << Element.build_region_before do |this|
      this["region-name"] = "dummy.header"
    end
    this << Element.build_region_after do |this|
      this["region-name"] = "dummy.right-footer"
    end
  end
  this << Element.build("fo:page-sequence-master") do |this|
    this["master-name"] = "dummy"
    this << Element.build("fo:repeatable-page-master-alternatives") do |this|
      this << Element.build("fo:conditional-page-master-reference") do |this|
        this["master-reference"] = "dummy.left"
        this["odd-or-even"] = "even"
      end
      this << Element.build("fo:conditional-page-master-reference") do |this|
        this["master-reference"] = "dummy.right"
        this["odd-or-even"] = "odd"
      end
    end
  end
  next this
end

converter.add(["dummy"], [""]) do |element|
  this = Nodes[]
  this << Element.build("fo:page-sequence") do |this|
    this["master-reference"] = "dummy"
    this["initial-page-number"] = "auto-even"
    this << Element.build("fo:static-content") do |this|
      this["flow-name"] = "dummy.header"
    end
    this << Element.build("fo:static-content") do |this|
      this["flow-name"] = "dummy.left-footer"
      this << call(element, "page-number", :left)
    end
    this << Element.build("fo:static-content") do |this|
      this["flow-name"] = "dummy.right-footer"
      this << call(element, "page-number", :right)
    end
    this << Element.build("fo:flow") do |this|
      this["flow-name"] = "dummy.body"
      this << Element.build("fo:block") do |this|
        this << ~"Dummy page"
      end
    end
  end
  next this
end
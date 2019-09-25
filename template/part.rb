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
      this << call(element, "page-number", :left)
    end
    this << Element.build("fo:static-content") do |this|
      this["flow-name"] = "part.right-footer"
      this << call(element, "page-number", :right)
    end
    this << Element.build("fo:flow") do |this|
      this["flow-name"] = "part.body"
      this << Element.build("fo:block") do |this|
        set_part_number
        this << ~"〈第 #{get_part_number} 部〉"
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
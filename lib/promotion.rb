module Superfiliate
  class Promotion
    def initialize(options)
      @prerequisite_skus = options[:prerequisite_skus]
      @eligible_skus = options[:eligible_skus]
      @discount_unit = options[:discount_unit]
      @discount_value = options[:discount_value]
    end

    def apply(line_items)
      line_items.first.discount
    end
  end
end

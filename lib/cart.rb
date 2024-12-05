module Superfiliate
  class Cart
    attr_reader :line_items

    def initialize(line_items)
      @line_items = line_items
    end

    def apply_promotion(promotion)
      promotion.apply @line_items
    end
  end
end

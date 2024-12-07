module Superfiliate
  class Cart
    attr_reader :line_items

    def initialize(line_items)
      @line_items = line_items
    end

    def apply_promotion(promotion)
      @total = nil
      promotion.apply @line_items
    end

    def add(line_item)
      @line_items << line_item
    end

    def total
      @total ||= line_items.reduce(0) { |total, item| total + item.price }
    end
  end
end

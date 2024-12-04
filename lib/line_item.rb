module Superfiliate
  class LineItem
    attr_reader :name, :price, :sku

    def initialize(name, price, sku)
      @name = name
      @price = price
      @sku = sku
    end

    def discounted?
      false
    end
  end
end

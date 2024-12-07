module Superfiliate
  class LineItem
    attr_reader :name, :price, :sku

    def initialize(name, price, sku)
      @name = name
      @price = price
      @sku = sku
      @discounted = false
    end

    def discounted?
      @discounted
    end

    def discount(unit, value)
      return if discounted?

      case unit
      when "percentage"
        @price -= (value / 100) * @price
        @discounted = true
      end
    end
  end
end

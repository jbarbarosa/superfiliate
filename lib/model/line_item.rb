module Superfiliate
  class LineItem
    attr_reader :name, :price, :sku

    def self.from_json(json)
      json&.map { |element| LineItem.new(element[:name], element[:price].to_f, element[:sku]) }
    end

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

    def to_hash(options = {})
      { name: @name, price: @price, sku: @sku }
    end
  end
end

module Superfiliate
  class LineItem
    attr_reader :name, :price, :sku

    def self.from_json(json)
      json&.map { |element| LineItem.new(element[:name], element[:price].to_f, element[:sku]) }
    end

    def initialize(name, price, sku, options = {})
      @name = name
      @price = format_price(price)
      @sku = sku
      @discounted = options[:discounted] || false
      self.freeze
    end

    def discounted?
      @discounted
    end

    def discount(unit, value)
      return self if discounted?

      case unit
      when "percentage"
        price = @price - (value / 100) * @price
        LineItem.new(name, price.to_i, sku, discounted: true)
      end
    end

    def to_hash(options = {})
      { name: @name, price: (@price.to_f / 100).round(2), sku: @sku }
    end

    def dup
      LineItem.new @name, @price, @sku, discounted: discounted?
    end

    private
      # for safety we should only do calculations against integers, and convert back for display
      def format_price(price)
        if price.kind_of? Float
          (price * 100).round
        else
          price.to_i
        end
      end
  end
end

module Superfiliate
  class LineItem
    attr_reader :name, :price, :sku

    def self.from_json(json)
      json&.map { |element| LineItem.new(element[:name], element[:price].to_f, element[:sku]) }
    end

    def initialize(name, price, sku)
      @name = name
      @price = format_price price
      @sku = sku
      @discounted = false
    end

    def discounted?
      @discounted
    end

    # CON: A good alternative here is a version where you don't need to mutate the original
    # object. Of course it would require you to keep a reference to the original cart
    # but it could be an interesting solution as well.
    #
    # For example it could make it easier to return a price comparsion in a future feature..
    def discount(unit, value)
      return if discounted?

      case unit
      when "percentage"
        @price -= (value / 100) * @price
        @discounted = true
      end
    end

    def to_hash(options = {})
      { name: @name, price: (@price / 100).round(2), sku: @sku }
    end

    private
      # PRO: Using integer for making safe calculations.
      #
      # for safety we should only do calculations against integers, and convert back for display
      def format_price(price)
        if price.kind_of? Float
          price * 100
        else
          price
        end
      end
  end
end

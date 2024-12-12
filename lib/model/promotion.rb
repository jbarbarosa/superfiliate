module Superfiliate
  class Promotion
    PERCENTAGE = "percentage"

    def initialize(options = {
      prerequisite_skus: [ "PEANUT-BUTTER", "COCOA", "FRUITY" ],
      eligible_skus: [ "BANANA-CAKE", "COCOA", "CHOCOLATE" ],
      discount_unit: "percentage",
      discount_value: 50.0
    })
      @prerequisite_skus = options[:prerequisite_skus]
      @eligible_skus = options[:eligible_skus]
      @discount_unit = options[:discount_unit]
      @discount_value = options[:discount_value]
    end

    def apply(line_items)
      return if line_items.nil?

      sorted = sort_by_cheapest(line_items)
      prerequisite = sorted.filter { |item| @prerequisite_skus.include? item.sku }
      return if prerequisite.empty?

      eligible = sorted.filter { |item| @eligible_skus.include? item.sku }
      return if eligible.empty?

      # PRO: Great catch here on the edge chase, since we should allow
      # getting a discount on your second COCOA box, but not if you're buying a singele one.
      #
      # In this case since you're working with line items object, the comparison here will work
      # as they're not the same object, but the same line item.
      if prerequisite.size == 1 && eligible.size == 1
        return if prerequisite.first == eligible.first
      end
      eligible.first.discount @discount_unit, @discount_value
    end

    def valid!
      # since there's no requirement for other discount units I only left this as an example
      # of what a more elaborate validation would look like
      unless @discount_unit == PERCENTAGE
        raise InvalidDiscountUnit.new("#{@discount_unit} is not a valid discount unit")
      end
      true
    end

    # CON: Could beneft from a linter such as rubocop, making sure the indentation is consistent
    private
      def sort_by_cheapest(line_items)
        line_items.sort_by(&:price)
      end
  end

  class InvalidDiscountUnit < Exception
    attr_reader :message

    def initialize(msg)
      @message = msg
    end
  end
end

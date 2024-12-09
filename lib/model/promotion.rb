module Superfiliate
  class Promotion
    PERCENTAGE = "percentage"

    def initialize(options = {
      prerequisite_skus: ["PEANUT-BUTTER", "COCOA", "FRUITY"],
      eligible_skus: ["BANANA-CAKE", "COCOA", "CHOCOLATE"],
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

      prereq = line_items.filter { |item| @prerequisite_skus.include? item.sku }
      return unless prereq.any?

      eligible = line_items.filter { |item| @eligible_skus.include? item.sku }
      return unless eligible.any?

      sort_by_cheapest(eligible)
        .first(prereq.size)
        .each { |item| item.discount @discount_unit, @discount_value }
    end

    def valid!
      # since there's no requirement for other discount units I only left this as an example
      # of what a more elaborate validation would look like
      unless @discount_unit == PERCENTAGE
        raise InvalidDiscountUnit.new("#{@discount_unit} is not a valid discount_unit") 
      end
      true
    end

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

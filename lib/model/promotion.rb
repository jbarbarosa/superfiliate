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
      return line_items if line_items.nil?

      grouped = group_line_items(line_items)
      return line_items unless eligible_for_promotion?(grouped)

      discounted = grouped[:eligible].first.discount(@discount_unit, @discount_value)
      result = line_items.map(&:dup)
      line_items.find_index(grouped[:eligible].first).then { |i| result[i] = discounted }
      result
    end

    def valid!
      # since there's no requirement for other discount units I only left this as an example
      # of what a more elaborate validation would look like
      unless @discount_unit == PERCENTAGE
        raise InvalidDiscountUnit.new("#{@discount_unit} is not a valid discount unit")
      end
      true
    end

    private
    def sort_by_cheapest(line_items)
      line_items.sort_by(&:price)
    end

    def group_line_items(line_items)
      group = { eligible: [], prerequisite: [] }
      sorted = sort_by_cheapest(line_items)
      sorted.each do |item|
        if @prerequisite_skus.include? item.sku
          group[:prerequisite] << item
        end

        if @eligible_skus.include? item.sku
          group[:eligible] << item
        end
      end

      group
    end

    def eligible_for_promotion?(grouped_items)
      return false if grouped_items[:prerequisite].empty? || grouped_items[:eligible].empty?

      if grouped_items[:prerequisite].size == 1 && grouped_items[:eligible].size == 1
        return false if grouped_items[:prerequisite].first == grouped_items[:eligible].first
      end

      true
    end
  end

  class InvalidDiscountUnit < Exception
    attr_reader :message

    def initialize(msg)
      @message = msg
    end
  end
end

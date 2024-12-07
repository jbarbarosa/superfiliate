module Superfiliate
  class Promotion
    def initialize(options)
      @prerequisite_skus = options[:prerequisite_skus]
      @eligible_skus = options[:eligible_skus]
      @discount_unit = options[:discount_unit]
      @discount_value = options[:discount_value]
    end

    def apply(line_items)
      prereq = line_items.filter { |item| @prerequisite_skus.include? item.sku }
      return unless prereq.any?

      eligible = line_items.filter { |item| @eligible_skus.include? item.sku }
      return unless eligible.any?

      sort_by_cheapest(eligible).first(1).each { |item| item.discount @discount_unit, @discount_value }
    end

    private
      def sort_by_cheapest(line_items)
        line_items.sort_by(&:price)
      end
  end
end

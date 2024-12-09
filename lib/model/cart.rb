require "securerandom"
require "json"

module Superfiliate
  class Cart
    attr_reader :reference, :line_items

    def initialize(line_items, reference = nil)
      @line_items = line_items
      @reference = reference || SecureRandom.uuid
    end

    def apply_promotion(promotion)
      @total = nil
      promotion.apply @line_items
    end

    def total
      @total ||= if line_items.nil?
        0 
      else 
        line_items.reduce(0) { |total, item| total + item.price }
      end
    end

    def as_json(options = {})
      JSON.generate({ reference: @reference, line_items: @line_items&.map(&:to_hash), total: (total / 100).round(2) })
    end
  end
end

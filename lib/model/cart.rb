require "securerandom"
require "json"
require_relative "line_item"

module Superfiliate
  class Cart
    attr_reader :reference, :line_items

    def self.from_json(json)
      Cart.new(
        LineItem.from_json(json[:cart][:lineItems]),
        json[:cart][:reference]
      )
    end

    def initialize(line_items, reference = nil)
      @line_items = line_items
      @reference = reference || SecureRandom.uuid
    end

    def apply_promotion(promotion)
      @total = nil
      @line_items = promotion.apply @line_items
    end

    def total
      @total ||= (line_items || []).sum { |item| item.price }
    end

    def as_json(options = {})
      JSON.generate({ reference: @reference, lineItems: @line_items&.map(&:to_hash), total: (total.to_f / 100).round(2) })
    end
  end
end

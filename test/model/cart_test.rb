require "test_helper"
require "debug"

class Superfiliate::CartTest < Minitest::Test
  def setup
    @line_items = [
      Superfiliate::LineItem.new("Peanut Butter", 30.0, "PEANUTS"),
      Superfiliate::LineItem.new("Fruity Loops", 50.0, "FRUITY"),
      Superfiliate::LineItem.new("Chocolate", 20.0, "CHOCOLATE")
    ]

    @cart = Superfiliate::Cart.new @line_items
  end

  def test_create_with_items
    assert_equal @cart.line_items.size, 3
  end

  def test_when_cart_is_created_should_not_have_any_discounts_applied
    assert @cart.line_items.filter(&:discounted?).empty?
  end

  def test_when_empty_should_report_total_as_0
    assert_equal 0, Superfiliate::Cart.new([]).total
  end

  def test_should_display_cart_total_price_after_promotion
    promotion = Superfiliate::Promotion.new({
      prerequisite_skus: [ "CHOCOLATE" ],
      eligible_skus: [ "PEANUTS" ],
      discount_unit: "percentage",
      discount_value: 50.0
    })

    assert_equal 10000, @cart.total
    @cart.apply_promotion promotion
    assert_equal 8500, @cart.total
  end
end

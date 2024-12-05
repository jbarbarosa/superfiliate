require "test_helper"

class Superfiliate::CartTest < Minitest::Test
  def setup
    @line_items = [
      Superfiliate::LineItem.new("Peanut Butter", 3000, "PEANUTS"),
      Superfiliate::LineItem.new("Chocolate", 2000, "CHOCOLATE")
    ]

    @cart = Superfiliate::Cart.new @line_items
  end

  def test_create_with_items
    assert_equal @cart.line_items.size, 2
  end

  def test_when_cart_is_created_should_not_have_any_discounts_applied
    assert @cart.line_items.filter(&:discounted?).empty?
  end

  def test_should_apply_discount_on_eligible_item
    promotion = Superfiliate::Promotion.new({
      prerequisite_skus: [ "CHOCOLATE" ],
      eligible_skus: [ "PEANUTS" ],
      discount_unit: "percentage",
      discount_value: 50.0
    })

    @cart.apply_promotion promotion

    assert_equal 1, @cart.line_items.filter(&:discounted?).size
  end
end

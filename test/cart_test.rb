require "test_helper"

class Superfiliate::CartTest < Minitest::Test
  def setup
    @line_items = [
      Superfiliate::LineItem.new("Peanut Butter", 3000, "PEANUTS"),
      Superfiliate::LineItem.new("Chocolate", 2000, "CHOCOLATE")
    ]
  end

  def test_create_with_items
    cart = Superfiliate::Cart.new @line_items
    assert_equal cart.line_items.size, 2
  end

  def test_when_cart_is_created_should_not_have_any_discounts_applied
    cart = Superfiliate::Cart.new @line_items
    assert cart.line_items.filter(&:discounted?).empty?
  end
end

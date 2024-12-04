require "test_helper"

class Superfiliate::PromotionTest < Minitest::Test
  def test_should_not_change_cart_when_empty
    cart = Superfiliate::Cart.new []
    assert_equal Superfiliate::Promotion.apply(cart), cart
  end
end

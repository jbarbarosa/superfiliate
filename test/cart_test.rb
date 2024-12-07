require "test_helper"

class Superfiliate::CartTest < Minitest::Test
  def setup
    @line_items = [
      Superfiliate::LineItem.new("Peanut Butter", 3000, "PEANUTS"),
      Superfiliate::LineItem.new("Fruity Loops", 5000, "FRUITY"),
      Superfiliate::LineItem.new("Chocolate", 2000, "CHOCOLATE")
    ]

    @cart = Superfiliate::Cart.new @line_items
  end

  def test_create_with_items
    assert_equal @cart.line_items.size, 3
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

  def test_should_not_apply_discount_for_non_eligible_items
    promotion = Superfiliate::Promotion.new({
      prerequisite_skus: [ "CHOCOLATE" ],
      eligible_skus: [ "TOOTHPASTE" ],
      discount_unit: "percentage",
      discount_value: 50.0
    })

    @cart.apply_promotion promotion

    assert_equal 0, @cart.line_items.filter(&:discounted?).size
  end

  def test_should_not_apply_discount_if_no_prerequisite_items
    promotion = Superfiliate::Promotion.new({
      prerequisite_skus: [ "TOOTHPASTE" ],
      eligible_skus: [ "PEANUTS" ],
      discount_unit: "percentage",
      discount_value: 50.0
    })

    @cart.apply_promotion promotion

    assert_equal 0, @cart.line_items.filter(&:discounted?).size
  end

  def test_should_apply_percentage_discount_when_eligible
    promotion = Superfiliate::Promotion.new({
      prerequisite_skus: [ "CHOCOLATE" ],
      eligible_skus: [ "PEANUTS" ],
      discount_unit: "percentage",
      discount_value: 50.0
    })

    @cart.apply_promotion promotion

    discounted = @cart.line_items.find { |item| item.sku == "PEANUTS" }
    assert_equal 1500, discounted.price
  end

  def test_should_display_cart_total_price
    promotion = Superfiliate::Promotion.new({
      prerequisite_skus: [ "CHOCOLATE" ],
      eligible_skus: [ "PEANUTS" ],
      discount_unit: "percentage",
      discount_value: 50.0
    })

    assert_equal @cart.total, 10000
    @cart.apply_promotion promotion
    assert_equal @cart.total, 8500
  end

  def test_should_apply_to_the_cheapest_eligible_item
    promotion = Superfiliate::Promotion.new({
      prerequisite_skus: [ "CHOCOLATE" ],
      eligible_skus: [ "PEANUTS", "FRUITY" ],
      discount_unit: "percentage",
      discount_value: 50.0
    })

    @cart.apply_promotion promotion
    peanuts = @cart.line_items.find { |item| item.sku == "PEANUTS" }
    fruity = @cart.line_items.find { |item| item.sku == "FRUITY" }

    assert peanuts.discounted?
    refute fruity.discounted?
  end

  def test_when_2_eligible_skus_are_available_should_apply_2_discounts
    promotion = Superfiliate::Promotion.new({
      prerequisite_skus: [ "CHOCOLATE" ],
      eligible_skus: [ "PEANUTS" ],
      discount_unit: "percentage",
      discount_value: 50.0
    })

    @cart.add Superfiliate::LineItem.new "Chocolate", 2000, "CHOCOLATE"
    @cart.add Superfiliate::LineItem.new "Peanuts", 3000, "PEANUTS"
    @cart.add Superfiliate::LineItem.new "Peanuts", 3000, "PEANUTS"

    assert_equal 18000, @cart.total
    @cart.apply_promotion promotion

    assert_equal 15000, @cart.total
    assert_equal @cart.line_items.filter(&:discounted?).size, 2
  end
end

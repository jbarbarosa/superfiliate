require "test_helper"
require "debug"

class Superfiliate::PromotionTest < Minitest::Test
  def setup
    @line_items = [
      Superfiliate::LineItem.new("Peanut Butter", 30.0, "PEANUTS"),
      Superfiliate::LineItem.new("Fruity Loops", 50.0, "FRUITY"),
      Superfiliate::LineItem.new("Chocolate", 20.0, "CHOCOLATE")
    ]

    @promotion = Superfiliate::Promotion.new({
      prerequisite_skus: [ "CHOCOLATE" ],
      eligible_skus: [ "PEANUTS", "FRUITY" ],
      discount_unit: Superfiliate::Promotion::PERCENTAGE,
      discount_value: 50.0
    })
    @promotion.valid!
  end

  def test_should_have_valid_discount_unit
    promotion = Superfiliate::Promotion.new({
      discount_unit: "dunno",
      discount_value: 50.0
    })

    assert_raises Superfiliate::InvalidDiscountUnit do
      promotion.valid!
    end
  end

  def test_should_apply_discount_on_eligible_item
    @line_items = @promotion.apply @line_items

    assert_equal 1, @line_items.filter(&:discounted?).size
  end

  def test_should_not_apply_discount_for_non_eligible_items
    promotion = Superfiliate::Promotion.new({
      prerequisite_skus: [ "CHOCOLATE" ],
      eligible_skus: [ "TOOTHPASTE" ],
      discount_unit: Superfiliate::Promotion::PERCENTAGE,
      discount_value: 50.0
    })

    @line_items = promotion.apply @line_items

    assert_equal 0, @line_items.filter(&:discounted?).size
  end

  def test_should_not_apply_discount_if_no_prerequisite_items
    promotion = Superfiliate::Promotion.new({
      prerequisite_skus: [ "TOOTHPASTE" ],
      eligible_skus: [ "PEANUTS" ],
      discount_unit: Superfiliate::Promotion::PERCENTAGE,
      discount_value: 50.0
    })

    @line_items = promotion.apply @line_items

    assert_equal 0, @line_items.filter(&:discounted?).size
  end

  def test_should_apply_percentage_discount_when_eligible
    promotion = Superfiliate::Promotion.new({
      prerequisite_skus: [ "CHOCOLATE" ],
      eligible_skus: [ "PEANUTS" ],
      discount_unit: Superfiliate::Promotion::PERCENTAGE,
      discount_value: 50.0
    })

    @line_items = promotion.apply @line_items

    discounted = @line_items.find { |item| item.sku == "PEANUTS" }
    assert_equal 1500, discounted.price
  end

  def test_should_apply_to_the_cheapest_eligible_item
    @promotion = Superfiliate::Promotion.new({
      prerequisite_skus: [ "PEANUT-BUTTER", "COCOA", "FRUITY" ],
      eligible_skus: [ "BANANA-CAKE", "COCOA", "CHOCOLATE" ],
      discount_unit: Superfiliate::Promotion::PERCENTAGE,
      discount_value: 50.0
    })

    @line_items = [
      Superfiliate::LineItem.new("PB", 4000, "PEANUT-BUTTER"),
      Superfiliate::LineItem.new("Cocoa", 5000, "COCOA"),
      Superfiliate::LineItem.new("Fruity", 2000, "FRUITY"),
      Superfiliate::LineItem.new("Banana Cake", 3000, "BANANA-CAKE"),
      Superfiliate::LineItem.new("Cocoa", 4000, "COCOA"),
      Superfiliate::LineItem.new("Chocolate", 6000, "CHOCOLATE")
    ]

    @line_items = @promotion.apply @line_items

    discounted = @line_items.filter(&:discounted?)
    assert_equal "BANANA-CAKE", discounted.first.sku
    assert_equal 1, discounted.size
  end

  def test_when_item_is_more_expensive_but_only_one_eligible_should_still_be_discounted
    @promotion = Superfiliate::Promotion.new({
      prerequisite_skus: [ "CHOCOLATE", "PEANUT-BUTTER" ],
      eligible_skus: [ "CHOCOLATE" ],
      discount_unit: Superfiliate::Promotion::PERCENTAGE,
      discount_value: 50.0
    })

    @line_items = [
      Superfiliate::LineItem.new("Chocolate", 3000, "CHOCOLATE"),
      Superfiliate::LineItem.new("Peanut Butter", 2000, "PEANUT-BUTTER")
    ]

    @line_items = @promotion.apply @line_items
    discounted = @line_items.filter(&:discounted?)
    assert_equal "CHOCOLATE", discounted.first.sku
    assert_equal 1, discounted.size
  end

  def test_when_item_is_both_prereq_and_eligible_should_not_discount_itself
    @promotion = Superfiliate::Promotion.new({
      prerequisite_skus: [ "CHOCOLATE" ],
      eligible_skus: [ "CHOCOLATE" ],
      discount_unit: Superfiliate::Promotion::PERCENTAGE,
      discount_value: 50.0
    })

    @line_items = [ Superfiliate::LineItem.new("Chocolate", 2000, "CHOCOLATE") ]

    @line_items = @promotion.apply @line_items

    assert_equal 0, @line_items.filter(&:discounted?).size
  end
end

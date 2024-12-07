require "test_helper"

class Superfiliate::PromotionTest < Minitest::Test
  def setup
    @line_items = [
      Superfiliate::LineItem.new("Peanut Butter", 3000, "PEANUTS"),
      Superfiliate::LineItem.new("Fruity Loops", 5000, "FRUITY"),
      Superfiliate::LineItem.new("Chocolate", 2000, "CHOCOLATE")
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
    @promotion.apply @line_items

    assert_equal 1, @line_items.filter(&:discounted?).size
  end

  def test_should_not_apply_discount_for_non_eligible_items
    promotion = Superfiliate::Promotion.new({
      prerequisite_skus: [ "CHOCOLATE" ],
      eligible_skus: [ "TOOTHPASTE" ],
      discount_unit: Superfiliate::Promotion::PERCENTAGE,
      discount_value: 50.0
    })

    promotion.apply @line_items

    assert_equal 0, @line_items.filter(&:discounted?).size
  end

  def test_should_not_apply_discount_if_no_prerequisite_items
    promotion = Superfiliate::Promotion.new({
      prerequisite_skus: [ "TOOTHPASTE" ],
      eligible_skus: [ "PEANUTS" ],
      discount_unit: Superfiliate::Promotion::PERCENTAGE,
      discount_value: 50.0
    })

    promotion.apply @line_items

    assert_equal 0, @line_items.filter(&:discounted?).size
  end

  def test_should_apply_percentage_discount_when_eligible
    promotion = Superfiliate::Promotion.new({
      prerequisite_skus: [ "CHOCOLATE" ],
      eligible_skus: [ "PEANUTS" ],
      discount_unit: Superfiliate::Promotion::PERCENTAGE,
      discount_value: 50.0
    })

    promotion.apply @line_items

    discounted = @line_items.find { |item| item.sku == "PEANUTS" }
    assert_equal 1500, discounted.price
  end

  def test_should_apply_to_the_cheapest_eligible_item
    @promotion.apply @line_items
    peanuts = @line_items.find { |item| item.sku == "PEANUTS" }
    fruity = @line_items.find { |item| item.sku == "FRUITY" }

    assert peanuts.discounted?
    refute fruity.discounted?
  end

  def test_when_2_eligible_skus_are_available_should_apply_2_discounts
    @line_items << Superfiliate::LineItem.new("Chocolate", 2000, "CHOCOLATE")
    @line_items << Superfiliate::LineItem.new("Peanuts", 3000, "PEANUTS")
    @line_items << Superfiliate::LineItem.new("Peanuts", 3000, "PEANUTS")

    @promotion.apply @line_items

    assert_equal @line_items.filter(&:discounted?).size, 2
  end
end

require "test_helper"

class Superfiliate::LineItemTest < Minitest::Test
  def setup
    @item = Superfiliate::LineItem.new("Peanut Butter", 30.0, "PEANUTS")
  end

  def test_should_tag_line_item_as_discounted
    refute @item.discounted?

    item = @item.discount("percentage", 50.0)

    assert item.discounted?
    assert_equal 1500, item.price
  end

  def test_should_not_apply_discounts_more_than_once
    item = @item.discount("percentage", 50.0)
    item = item.discount("percentage", 50.0)

    assert item.discounted?
    assert_equal 1500, item.price
  end

  def test_should_convert_input_float_to_integer
    @item = Superfiliate::LineItem.new("Peanut Butter", 30.0, "PEANUTS")
    assert_equal 3000, @item.price
  end
end

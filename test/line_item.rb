require "test_helper"

class Superfiliate::LineItemTest < Minitest::Test
  def test_should_tag_line_item_as_discounted
    item = Superfiliate::LineItem.new("Peanut Butter", 3000, "PEANUTS")
    refute item.discounted?

    item.discount("percentage", 50.0)

    assert item.discounted?
    assert_equal 1500, item.price
  end
end

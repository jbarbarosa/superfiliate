require "test_helper"

class Superfiliate::CartTest < Minitest::Test
  def test_create_with_items
    line_items = [ Superfiliate::LineItem.new("Peanut Butter", 3000, "PEANUTS"), Superfiliate::LineItem.new("Chocolate", 2000, "CHOCOLATE") ]
    assert_equal Superfiliate::Cart.new(line_items).line_items.size, 2
  end
end

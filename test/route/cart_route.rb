require "test_helper"
require "rack/test"
require "route/cart_route"

class CartDiscountTest < Minitest::Test
  include Rack::Test::Methods

  # Specify the Sinatra app being tested
  def app
    Sinatra::Application
  end

  def test_cart_should_calculate_discount
    payload = {
      cart: {
        reference: "2d832fe0-6c96-4515-9be7-4c00983539c1",
        lineItems: [
          { name: "Peanut Butter", price: "39.0", sku: "PEANUT-BUTTER" },
          { name: "Fruity", price: "34.99", sku: "FRUITY" },
          { name: "Chocolate", price: "32", sku: "CHOCOLATE" }
        ]
      }
    }.to_json

    post "/carts/discount", payload, { "CONTENT_TYPE" => "application/json", "HTTP_HOST" => "localhost" }

    assert last_response.ok?, "Expected response to be OK, was #{last_response.status}"
    assert_equal 89.99, JSON.parse(last_response.body)["total"]
  end

  def test_should_error_on_an_invalid_payload
    payload = {
      cart: {
        ref: "2d832fe0-6c96-4515-9be7-4c00983539c1",
        itemz: [
          { namez: "Peanut Butter", sku: "PEANUT-BUTTER" },
          { namez: "Fruity", price: "34.99", sku: "FRUITY" },
          { namez: "Chocolate", price: "32", sku: "CHOCOLATE" }
        ]
      }
    }.to_json

    post "/carts/discount", payload, { "CONTENT_TYPE" => "application/json", "HTTP_HOST" => "localhost" }
    refute last_response.ok?, "Expected response to be 422, was #{last_response.status}"
  end
end

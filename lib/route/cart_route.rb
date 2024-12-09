require "sinatra"
require_relative "../model/cart"
require_relative "../model/line_item"
require_relative "../model/promotion"

before do
  content_type :json
end

post "/carts/discount" do
  body = request.body.read
  json_payload = JSON.parse body, symbolize_names: true
  cart = Superfiliate::Cart.new Superfiliate::LineItem.from_json(json_payload[:cart][:lineItems])
  cart.apply_promotion Superfiliate::Promotion.new({
    prerequisite_skus: ["PEANUT-BUTTER", "COCOA", "FRUITY"],
    eligible_skus: ["BANANA-CAKE", "COCOA", "CHOCOLATE"],
    discount_unit: "percentage",
    discount_value: 50.0 
  })
  cart.as_json
end



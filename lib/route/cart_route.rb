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
  cart.apply_promotion Superfiliate::Promotion.new
  cart.as_json
end



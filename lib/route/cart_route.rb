require "sinatra"
require "json-schema"
require_relative "../model/cart"
require_relative "../model/line_item"
require_relative "../model/promotion"

before do
  content_type :json
end

post "/carts/discount" do
  body = request.body.read
  json_payload = JSON.parse body, symbolize_names: true
  validation_errors = JSON::Validator.fully_validate({
  "type" => "object",
  "required" => ["cart"],
  "properties" => {
    "cart" => {
      "type" => "object",
      "properties" => {
        "reference" => { "type" => "string" },
        "lineItems" => {
          "type" => "array",
          "properties" => {
            "name" => { "type" => "string" },
            "price" => { "type" => "string" },
            "sku" => { "type" => "string" }
          }
        }
      }
    }
  }
}, json_payload, strict: true)
  return status(422).then { validation_errors.to_json } if validation_errors.any?
  cart = Superfiliate::Cart.new Superfiliate::LineItem.from_json(json_payload[:cart][:lineItems])
  cart.apply_promotion Superfiliate::Promotion.new
  cart.as_json
end



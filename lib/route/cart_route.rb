require "sinatra"
require "json-schema"
require_relative "cart_schema"
require_relative "../model/cart"
require_relative "../model/promotion"

before do
  content_type :json
end

configure do
  set :bind, "0.0.0.0"
end

post "/carts/discount" do
  body = request.body.read
  json_payload = JSON.parse(body, symbolize_names: true)
  validation_errors = JSON::Validator.fully_validate(schema, json_payload, strict: true)
  return status(422).then { { errors: validation_errors }.to_json } if validation_errors.any?

  cart = Superfiliate::Cart.from_json(json_payload)
  cart.apply_promotion Superfiliate::Promotion.new
  cart.as_json
end

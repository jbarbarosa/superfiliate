## Running
With docker installed is as easy as 
```ruby
chmod +x bin/run && bin/run
```

Or you can install Ruby 3 locally and run 
```ruby
ruby lib/route/cart_route.rb
```

## Testing
There will be a endpoint available at localhost:4567/carts/discount that accepts the test payload
```json
{
  "cart": {
    "reference": "2d832fe0-6c96-4515-9be7-4c00983539c0",
    "lineItems": [
      { "name": "Peanut Butter", "price": "39.0", "sku": "PEANUT-BUTTER" },
      { "name": "Fruity", "price": "34.9", "sku": "FRUITY" },
      { "name": "Chocolate", "price": "32", "sku": "CHOCOLATE" }
    ]
  } 
}  
```

This should yield a discount on `Chocolate`, since Peanut Butter and Fruity both work as prerequisites

Since the requirement was not 100% clear on what should happen with multiple prerequisites and multiple eligible SKUs,
I decided that it would be sensible to issue discounts for every prerequisite-eligible pair in the cart. So having 2 eligible SKUs
should yield 2 discounts, based on their price

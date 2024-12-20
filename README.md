## Running
With docker installed is as easy as 
```sh
chmod +x bin/run && bin/run
```

Or you can install Ruby 3 & Bundle locally and run 
```sh
bundle && ruby lib/route/cart_route.rb
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

This should yield a discount on `Chocolate`, since `Peanut Butter` and `Fruity` both work as prerequisites


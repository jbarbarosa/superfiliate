def schema = {
  "type" => "object",
  "required" => ["cart"],
  "properties" => {
    "cart" => {
      "type" => "object",
      "properties" => {
        "reference" => { "type" => "string" },
        "lineItems" => {
          "type" => "array",
          "items" => {
            "type": "object",
            "properties" => {
              "name" => { "type" => "string" },
              "price" => { "type" => "string" },
              "sku" => { "type" => "string" }
            }
          }
        }
      }
    }
  }
}

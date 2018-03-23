json.extract! product, :id, :item, :price, :tax_exempt, :import_duty, :created_at, :updated_at
json.url product_url(product, format: :json)

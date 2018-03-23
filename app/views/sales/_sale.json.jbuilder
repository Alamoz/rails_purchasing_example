json.extract! sale, :id, :tax_exempt_amount, :taxable_amount, :import_duty_amount, :taxable_total, :import_duty_total, :grand_total, :created_at, :updated_at
json.url sale_url(sale, format: :json)

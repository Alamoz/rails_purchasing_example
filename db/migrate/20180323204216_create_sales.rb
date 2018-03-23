class CreateSales < ActiveRecord::Migration[5.1]
  def change
    create_table :sales do |t|
      t.float :tax_exempt_amount
      t.float :taxable_amount
      t.float :import_duty_amount
      t.float :taxable_total
      t.float :import_duty_total
      t.float :grand_total

      t.timestamps
    end
  end
end

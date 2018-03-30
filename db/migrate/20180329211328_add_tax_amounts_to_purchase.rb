class AddTaxAmountsToPurchase < ActiveRecord::Migration[5.1]
  def change
    add_column :purchases, :tax_total, :float, default: 0
    add_column :purchases, :import_duty_total, :float, default: 0
  end
end

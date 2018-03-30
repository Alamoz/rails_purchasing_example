class AddTotalsToPurchase < ActiveRecord::Migration[5.1]
  def change
    add_column :products, :sub_total, :float, default: 0
    add_column :products, :total, :float, default: 0
  end
end

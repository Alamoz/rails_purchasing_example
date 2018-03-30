class AddTotalsToPurchase < ActiveRecord::Migration[5.1]
  def change
    add_column :purchases, :sub_total, :float, default: 0
    add_column :purchases, :total, :float, default: 0
  end
end

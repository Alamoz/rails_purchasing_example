class AddSaleIdToPurchases < ActiveRecord::Migration[5.1]
  def change
    add_column :purchases, :sale_id, :integer
    remove_column :purchases, :sales_id, :integer
  end
end

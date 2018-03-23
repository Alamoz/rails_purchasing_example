class CreatePurchases < ActiveRecord::Migration[5.1]
  def change
    create_table :purchases do |t|
      t.integer :sales_id
      t.integer :product_id
      t.integer :quantity, default: 1

      t.timestamps
    end
  end
end

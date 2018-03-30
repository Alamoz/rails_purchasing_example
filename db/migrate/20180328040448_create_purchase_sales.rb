class CreatePurchaseSales < ActiveRecord::Migration[5.1]
  def change
    create_table :purchase_sales do |t|
      t.integer :purchase_id
      t.integer :sale_id

      t.timestamps
    end
  end
end

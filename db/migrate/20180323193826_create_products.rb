class CreateProducts < ActiveRecord::Migration[5.1]
  def change
    create_table :products do |t|
      t.string :item
      t.float :price
      t.boolean :tax_exempt, default: false
      t.boolean :import_duty, default: false

      t.timestamps
    end
  end
end

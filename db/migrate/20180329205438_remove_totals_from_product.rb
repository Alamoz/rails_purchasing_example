class RemoveTotalsFromProduct < ActiveRecord::Migration[5.1]
  def change
    remove_column :products, :sub_total, :float, default: 0
    remove_column :products, :total, :float, default: 0
  end
end

class ChangeSalesDefaults < ActiveRecord::Migration[5.1]
  def change
  	change_column_default :sales, :tax_exempt_amount, 0
  	change_column_default :sales, :taxable_amount, 0
  	change_column_default :sales, :import_duty_amount, 0
  	change_column_default :sales, :taxable_total, 0
  	change_column_default :sales, :import_duty_total, 0
  	change_column_default :sales, :grand_total, 0
  end
end

class Sale < ApplicationRecord
  has_many :purchases, inverse_of: :sale
  accepts_nested_attributes_for :purchases, reject_if: :all_blank, allow_destroy: true


  private
  
end

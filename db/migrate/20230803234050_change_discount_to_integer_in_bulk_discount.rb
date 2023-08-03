class ChangeDiscountToIntegerInBulkDiscount < ActiveRecord::Migration[7.0]
  def change
    change_column :bulk_discounts, :discount, :integer
  end
end

class ChangePercentDiscountNameToDiscountInBulkDiscount < ActiveRecord::Migration[7.0]
  def change
    rename_column :bulk_discounts, :percent_discount, :discount
  end
end

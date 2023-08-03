class CreateBulkDiscount < ActiveRecord::Migration[7.0]
  def change
    create_table :bulk_discounts do |t|
      t.float :percent_discount
      t.integer :quantity
      t.references :merchant, null: false, foreign_key: true

      t.timestamps
    end
  end
end

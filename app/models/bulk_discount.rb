class BulkDiscount < ApplicationRecord
  belongs_to :merchant

  validates :discount, :quantity, presence: true

  def self.best_discount(item_quantity)
    BulkDiscount.where("quantity <= ?", item_quantity).order(discount: :desc).first
  end
end
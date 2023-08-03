class BulkDiscount < ApplicationRecord
  belongs_to :merchant

  validates :discount, :quantity, presence: true
end
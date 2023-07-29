class Item < ApplicationRecord 
  belongs_to :merchant
  has_many :invoice_items
  has_many :invoices, through: :invoice_items

  validates :name, :description, :unit_price, presence: true

  def current_price
    price = (unit_price * 0.01).round(3)
    "$#{price}"
  end
end 
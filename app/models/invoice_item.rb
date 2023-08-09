class InvoiceItem < ApplicationRecord 
  enum :status, { pending: 0, packaged: 1, shipped: 2 }
  belongs_to :item
  belongs_to :invoice
  has_one :merchant, through: :item
  has_many :bulk_discounts, through: :merchant

  def price_to_currency
    ActiveSupport::NumberHelper::number_to_currency(unit_price.to_f / 100)
  end

  def dollar_price
    unit_price * 0.01
  end

  def best_bulk_discount
    bulk_discounts
    .where("? >= bulk_discounts.quantity", quantity)
    .order(discount: :desc)
    .first
  end

  def bulk_discount_unit_price
    bulk_discount = best_bulk_discount

    if bulk_discount
      unit_price - (unit_price * (bulk_discount.discount * 0.01))
    else
      unit_price
    end
  end

  def self.sum_bulk_discount_unit_price
    InvoiceItem.sum{ |ii| ii.bulk_discount_unit_price * ii.quantity }
  end
end

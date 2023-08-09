class Invoice < ApplicationRecord
  enum :status, { "in progress" => 0, "completed" => 1, "cancelled" => 2 }
  belongs_to :customer
  has_many :transactions, dependent: :destroy 
  has_many :invoice_items, dependent: :destroy 
  has_many :items, through: :invoice_items

  validates :status, presence: true

  def self.incomplete_invoices
    joins(:invoice_items).where.not(invoice_items: {status: 2}).order(created_at: :desc)
  end

  def formatted_date
    created_at.strftime("%A, %B %-e, %Y")
  end
  
  def total_revenue
    invoice_items.sum("unit_price * quantity")
  end

  def total_revenue_to_currency
    ActiveSupport::NumberHelper::number_to_currency(total_revenue.to_f / 100)
  end

  def self.status_list_for_select_menu
    statuses.keys.map { |status| [status.titleize, status]}
    #per note from Chris Simmons "That looks good to us; this Ruby isn’t doing anything that AR could do, so it can be used like this."
  end
  
  def merchant_invoice_items(merchant_id)
    invoice_items.joins(:item).where("items.merchant_id = #{merchant_id}")
  end

  def merchant_revenue(merchant_id)
    invoice_items
    .joins(:item)
    .where("items.merchant_id = #{merchant_id}")
    .sum("invoice_items.unit_price * quantity")
  end

  def merchant_revenue_to_currency(merchant_id)
    ActiveSupport::NumberHelper::number_to_currency(merchant_revenue(merchant_id).to_f / 100)
  end

  # Status of trying to solve this problem with an active record query
  # def merchant_bulk_discount_revenue(merchant_id)
  #   invoice_items
  #   .select("invoice_items.*, MAX(discount) as best_discount")
  #   .joins(:bulk_discounts)
  #   .where("invoice_items.quantity >= bulk_discounts.quantity")
  #   .where("items.merchant_id = ?", merchant_id)
  #   .where("bulk_discounts.merchant_id = ?", merchant_id)
  #   .group("invoice_items.id")
  # end

  def merchant_discounted_revenue_dollars(merchant_id)
    merchant_invoice_items(merchant_id).sum_bulk_discount_unit_price * 0.01
  end

end

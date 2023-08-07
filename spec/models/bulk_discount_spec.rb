require "rails_helper"

RSpec.describe BulkDiscount, type: :model do
  describe "Relationships" do
    it {should belong_to :merchant}
  end

  describe "Validations" do
    it {should validate_presence_of :discount}
    it {should validate_presence_of :quantity}
  end

  before :each do
    # Merchants
    @merchant_a = create(:merchant)

    # Bulk Discounts
    @discount_1a = create(:bulk_discount, discount: 20, quantity: 10, merchant_id: @merchant_a.id)
    @discount_2a = create(:bulk_discount, discount: 30, quantity: 15, merchant_id: @merchant_a.id)
    @discount_3a = create(:bulk_discount, discount: 15, quantity: 6, merchant_id: @merchant_a.id)
    @discount_4a = create(:bulk_discount, discount: 10, quantity: 20, merchant_id: @merchant_a.id)

    # Items
    @item_1a = create(:item, merchant_id: @merchant_a.id, unit_price: 10000)
    @item_2a = create(:item, merchant_id: @merchant_a.id, unit_price: 1000)
    @item_3a = create(:item, merchant_id: @merchant_a.id, unit_price: 5000)

    # Invoice
    @invoice_1 = create(:invoice)

    # Invoice Items
    @invoice_item_1_1a = create(:invoice_item, quantity: 10, unit_price: @item_1a.unit_price, item_id: @item_1a.id, invoice_id: @invoice_1.id)
    @invoice_item_1_2a = create(:invoice_item, quantity: 5, unit_price: @item_2a.unit_price, item_id: @item_2a.id, invoice_id: @invoice_1.id)
    @invoice_item_1_3a = create(:invoice_item, quantity: 15, unit_price: @item_3a.unit_price, item_id: @item_3a.id, invoice_id: @invoice_1.id)
  end

  describe "Class Methods" do
    describe ".best_discount" do
      it "returns the best discount for a provided invoice_item" do
        expect(BulkDiscount.best_discount(@invoice_item_1_1a.quantity)).to eq(@discount_1a)
        expect(BulkDiscount.best_discount(@invoice_item_1_2a.quantity)).to eq(nil)
        expect(BulkDiscount.best_discount(@invoice_item_1_3a.quantity)).to eq(@discount_2a)
      end
    end
  end
end

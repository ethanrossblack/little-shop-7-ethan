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
  end

  describe "Class Methods" do
    describe ".best_discount" do
      it "returns the best discount for a provided item_quantity" do
        expect(BulkDiscount.best_discount(12)).to eq(@discount_1a)
        expect(BulkDiscount.best_discount(5)).to eq(nil)
        expect(BulkDiscount.best_discount(20)).to eq(@discount_2a)
      end
    end
  end
end

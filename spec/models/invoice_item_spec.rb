require 'rails_helper'

RSpec.describe InvoiceItem, type: :model do 
  describe 'relationships' do 
    it { should belong_to :item }
    it { should belong_to :invoice }
    it { should have_one(:merchant).through(:item)}
    it { should have_many(:bulk_discounts).through(:merchant)}
  end

  describe "instance methods" do
    before :each do
      @customer = Customer.create!(first_name: 'Joey', last_name: 'Ondricka')
      @merchant = Merchant.create!(name: 'Schroeder-Jerde')
      @item = @merchant.items.create!(name: 'Qui Esse', description: 'Nihil autem sit odio inventore deleniti', unit_price: 75107)
      @invoice = @customer.invoices.create!(status: 'in progress', created_at: Time.new(2000))
      @invoice_item = InvoiceItem.create!(invoice_id: @invoice.id, item_id: @item.id, quantity: 5, unit_price: 13635, status: 'packaged')
    end

    describe "#dollar_price" do
      it "converts the unit price (cents) into dollars" do
        expect(@invoice_item.dollar_price).to eq(136.35)
      end
    end
    describe "#price_to_currency" do
      it "returns a price in currency format" do
        customer = Customer.create!(first_name: "Teddy", last_name: "Handyman")
        merchant = Merchant.create!(name: "Bob's Burgers")
        item = Item.create!(name: "Burger", description: "Delicious", unit_price: 1000, merchant_id: merchant.id)
        invoice = Invoice.create!(customer: customer, status: 1)
        invoice_item = InvoiceItem.create!(item_id: item.id, invoice_id: invoice.id, quantity: 10, unit_price: 1000, status: 1)

        expect(invoice_item.price_to_currency).to eq("$10.00")
      end
    end

    describe "Bulk Discount Methods" do
      before :each do
        # Merchants
        @merchant_a = create(:merchant)
        @merchant_b = create(:merchant)
    
        # Bulk Discounts
        @discount_1a = create(:bulk_discount, discount: 20, quantity: 10, merchant_id: @merchant_a.id)
        @discount_2a = create(:bulk_discount, discount: 30, quantity: 15, merchant_id: @merchant_a.id)
        @discount_3a = create(:bulk_discount, discount: 15, quantity: 6, merchant_id: @merchant_a.id)
        @discount_4a = create(:bulk_discount, discount: 10, quantity: 20, merchant_id: @merchant_a.id)
        
        @discount_1b = create(:bulk_discount, discount: 99, quantity: 1, merchant_id: @merchant_b.id)
    
        # Items
        @item_1a = create(:item, merchant_id: @merchant_a.id, unit_price: 10000)
        @item_2a = create(:item, merchant_id: @merchant_a.id, unit_price: 1000)
        @item_3a = create(:item, merchant_id: @merchant_a.id, unit_price: 10000)
    
        # Invoice
        @invoice_1 = create(:invoice)
    
        # Invoice Items
        @invoice_item_1_1a = create(:invoice_item, quantity: 10, unit_price: @item_1a.unit_price, item_id: @item_1a.id, invoice_id: @invoice_1.id)
        @invoice_item_1_2a = create(:invoice_item, quantity: 5, unit_price: @item_2a.unit_price, item_id: @item_2a.id, invoice_id: @invoice_1.id)
        @invoice_item_1_3a = create(:invoice_item, quantity: 15, unit_price: @item_3a.unit_price, item_id: @item_3a.id, invoice_id: @invoice_1.id)
      end

      describe "#best_bulk_discount" do
        it "returns the best eligible bulk_discount for an invoice_item instance from its associated merchant" do
          expect(@invoice_item_1_1a.best_bulk_discount).to eq @discount_1a
          expect(@invoice_item_1_3a.best_bulk_discount).to eq @discount_2a
        end

        it "returns nil if an invoice_item is not eligible for a bulk discount" do
          expect(@invoice_item_1_2a.best_bulk_discount).to eq nil
        end
      end

      describe "#bulk_discount_unit_price" do
        it "returns the discounted price (in cents) for a single invoice_item after applying the best eligible bulk_discount" do
          expect(@invoice_item_1_1a.bulk_discount_unit_price).to eq 8000
          expect(@invoice_item_1_3a.bulk_discount_unit_price).to eq 7000
        end
        
        it "returns an invoice_items default unit_price if that invoice_item is not eligible for a bulk_discount" do
          expect(@invoice_item_1_2a.bulk_discount_unit_price).to eq(@invoice_item_1_2a.unit_price)
        end
      end
    end
  end

  describe "class methods" do
    describe ".sum_bulk_discount_unit_price" do
      before :each do
        # Merchants
        @merchant_a = create(:merchant)
        @merchant_b = create(:merchant)
    
        # Bulk Discounts
        @discount_1a = create(:bulk_discount, discount: 20, quantity: 10, merchant_id: @merchant_a.id)
        @discount_2a = create(:bulk_discount, discount: 30, quantity: 15, merchant_id: @merchant_a.id)
        @discount_3a = create(:bulk_discount, discount: 15, quantity: 6, merchant_id: @merchant_a.id)
        @discount_4a = create(:bulk_discount, discount: 10, quantity: 20, merchant_id: @merchant_a.id)
        
        @discount_1b = create(:bulk_discount, discount: 75, quantity: 1, merchant_id: @merchant_b.id)
    
        # Items
        @item_1a = create(:item, merchant_id: @merchant_a.id, unit_price: 10000)
        @item_2a = create(:item, merchant_id: @merchant_a.id, unit_price: 10000)
        @item_3a = create(:item, merchant_id: @merchant_a.id, unit_price: 10000)

        @item_1b = create(:item, merchant_id: @merchant_b.id, unit_price: 10000)
    
        # Invoice
        @invoice_1 = create(:invoice)
    
        # Invoice Items
        @invoice_item_1_1a = create(:invoice_item, quantity: 10, unit_price: @item_1a.unit_price, item_id: @item_1a.id, invoice_id: @invoice_1.id)
        @invoice_item_1_2a = create(:invoice_item, quantity: 5, unit_price: @item_2a.unit_price, item_id: @item_2a.id, invoice_id: @invoice_1.id)
        @invoice_item_1_3a = create(:invoice_item, quantity: 15, unit_price: @item_3a.unit_price, item_id: @item_3a.id, invoice_id: @invoice_1.id)

        @invoice_item_1_1b = create(:invoice_item, quantity: 2, unit_price: @item_1b.unit_price, item_id: @item_1b.id, invoice_id: @invoice_1.id)
      end

      it "returns (in cents) the sum total cost (price * quantity) for a collection of invoice_items after applying the best eligible bulk discount to each invoice_item" do
        # Expected values of single full bulk discount cost
        merchant_a_invoice_items = InvoiceItem.joins(:item).where("items.merchant_id = ?", @merchant_a.id)  # => 235000
        merchant_b_invoice_items = InvoiceItem.joins(:item).where("items.merchant_id = ?", @merchant_b.id)  # =>   5000
        
        expect(merchant_a_invoice_items.sum_bulk_discount_unit_price).to eq(235000)
        expect(merchant_b_invoice_items.sum_bulk_discount_unit_price).to eq(5000)
        expect(InvoiceItem.sum_bulk_discount_unit_price).to eq(240000)
      end
    end
  end
end

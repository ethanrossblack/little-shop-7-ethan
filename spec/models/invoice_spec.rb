require "rails_helper"

RSpec.describe Invoice, type: :model do
  describe "relationships" do
    it { should belong_to :customer }
    it { should have_many :transactions }
    it { should have_many :invoice_items }
    it { should have_many(:items).through(:invoice_items) }
  end

  describe "validations" do
    it { should validate_presence_of :status }
  end

  describe "class methods" do
    describe ".status_list_for_select_menu" do
      it "returns an array of statuses for select menu" do
        expected = [["In Progress", "in progress"], ["Completed", "completed"], ["Cancelled", "cancelled"]]
        
        expect(Invoice.status_list_for_select_menu).to eq(expected)
      end
    end
    describe ".incomplete_invoices" do
      before :each do
        invoice_spec_test_data
      end

      it "Can return all invoices with unshipped items ordered by oldest to newest" do
        incomplete_invoices = Invoice.incomplete_invoices
    
        expect(incomplete_invoices.count).to eq(6)
        expect(incomplete_invoices.sample).to be_a(Invoice)
        expect(incomplete_invoices).to eq([@invoice_8, @invoice_5, @invoice_3, @invoice_1, @invoice_2, @invoice_4])
      end
    end
  end

  describe 'instance methods' do 
    describe '#total_revenue' do
      before :each do
        invoice_spec_test_data
      end

      it 'returns the total revenue for an invoice in cents' do
        expect(@invoice_1.total_revenue).to eq(68175)
        expect(@invoice_2.total_revenue).to eq(209916)
      end
      
      it "returns an integer for total revenue" do
        invoice_spec_test_data

        expect(@invoice_1.total_revenue).to be_a(Integer)
      end
    end

    describe "#total_revenue_to_currency" do
      before :each do
        invoice_spec_test_data
      end

      it 'returns the total revenue for an invoice in dollars' do
        expect(@invoice_1.total_revenue_to_currency).to eq("$681.75")
        expect(@invoice_2.total_revenue_to_currency).to eq("$2,099.16")
      end

      it "returns a string for total revenue to currency" do
        expect(@invoice_1.total_revenue_to_currency).to be_a(String)
      end
    end

    describe "#merchant_invoice_items(merchant_id)" do
      before :each do
        merchant_invoice_test_data
      end

      it "returns the invoice_items for a specific a merchant" do
        # invoice_1 has two invoice_items from merchant_1
        merch1_inv1_expected = [@invoice1_item_1, @invoice1_item_2]
        merch1_inv1_result = @invoice_1.merchant_invoice_items(@merchant_1.id)
        expect(merch1_inv1_result).to eq(merch1_inv1_expected)

        # invoice_2 has one invoice_item from merchant_1 and one invoice_item from merchant_2
        # invoice_2 for merchant_1
        merch1_inv2_expected = [@invoice2_item_3]
        merch1_inv2_result = @invoice_2.merchant_invoice_items(@merchant_1.id)
        expect(merch1_inv2_result).to eq(merch1_inv2_expected)
        
        # invoice_2 for merchant_2
        merch2_inv2_expected = [@invoice2_item_4]
        merch2_inv2_result = @invoice_2.merchant_invoice_items(@merchant_2.id)
        expect(merch2_inv2_result).to eq(merch2_inv2_expected)
      end
    end

    describe "#merchant_revenue(merchant_id)" do
      before :each do
        merchant_invoice_test_data
      end

      it "returns the total revenue from a specific merchant's items" do
        # invoice_1 has two invoice_items from merchant_1
        merch1_inv1_item_1_rev = @invoice1_item_1.unit_price * @invoice1_item_1.quantity  # =>  68175
        merch1_inv1_item_2_rev = @invoice1_item_2.unit_price * @invoice1_item_2.quantity  # => 667470
        merch1_inv1_total_rev = merch1_inv1_item_2_rev + merch1_inv1_item_1_rev           # => 735645

        expect(@invoice_1.merchant_revenue(@merchant_1.id)).to eq(merch1_inv1_total_rev)

        # invoice_2 has one invoice_item from merchant_1 and one invoice_item from merchant_2
        # invoice_2 for merchant_1
        merch1_inv2_item_3_rev = @invoice2_item_3.unit_price * @invoice2_item_3.quantity
        
        expect(@invoice_2.merchant_revenue(@merchant_1.id)).to eq(merch1_inv2_item_3_rev) # => 209916
        
        # invoice_2 for merchant_2
        merch2_inv2_item_4_rev = @invoice2_item_4.unit_price * @invoice2_item_4.quantity
        
        expect(@invoice_2.merchant_revenue(@merchant_2.id)).to eq(merch2_inv2_item_4_rev) # => 692469
      end
    end
    
    describe "#merchant_revenue_to_currency(merchant_id)" do
      before :each do
        merchant_invoice_test_data
      end

      it "returns the total revenue from a specific merchant's items as a formatted string" do
        expect(@invoice_1.merchant_revenue_to_currency(@merchant_1.id)).to eq("$7,356.45")
        
        expect(@invoice_2.merchant_revenue_to_currency(@merchant_1.id)).to eq("$2,099.16")
        
        expect(@invoice_2.merchant_revenue_to_currency(@merchant_2.id)).to eq("$6,924.69")
      end
    end

    describe "formatted_date" do
      it "returns a formatted date" do 
        merchant_invoice_test_data
        expect(@invoice_1.formatted_date).to eq("Saturday, January 1, 2000")
      end
    end
# ================================================================
    describe "#merchant_discounted_revenue_dollars" do
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

      it "returns the total discounted revenue in dollars for a merchant with bulk discounts applied" do
        expect(@invoice_1.merchant_discounted_revenue_dollars(@merchant_a.id)).to eq(2350)
        expect(@invoice_1.merchant_discounted_revenue_dollars(@merchant_b.id)).to eq(50)
      end
    end
  end
end

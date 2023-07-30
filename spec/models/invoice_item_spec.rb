require 'rails_helper'

RSpec.describe InvoiceItem, type: :model do 
  describe 'relationships' do 
    it { should belong_to :item }
    it { should belong_to :invoice }
  end

<<<<<<< HEAD
  before :each do
    @customer = Customer.create!(first_name: 'Joey', last_name: 'Ondricka')
    @merchant = Merchant.create!(name: 'Schroeder-Jerde')
    @item = @merchant.items.create!(name: 'Qui Esse', description: 'Nihil autem sit odio inventore deleniti', unit_price: 75107)
    @invoice = @customer.invoices.create!(status: 'in progress', created_at: Time.new(2000))
    @invoice_item = InvoiceItem.create!(invoice_id: @invoice.id, item_id: @item.id, quantity: 5, unit_price: 13635, status: 'packaged')

  end

  describe "instance methods" do
    describe "#dollar_price" do
      it "converts the unit price (cents) into dollars" do
        expect(@invoice_item.dollar_price).to eq(136.35)
      end
=======
  describe "#price_to_currency" do
    it "returns a price in currency format" do
      customer = Customer.create!(first_name: "Teddy", last_name: "Handyman")
      merchant = Merchant.create!(name: "Bob's Burgers")
      item = Item.create!(name: "Burger", description: "Delicious", unit_price: 1000, merchant_id: merchant.id)
      invoice = Invoice.create!(customer: customer, status: 1)
      invoice_item = InvoiceItem.create!(item_id: item.id, invoice_id: invoice.id, quantity: 10, unit_price: 1000, status: 1)

      expect(invoice_item.price_to_currency).to eq("$10.00")
>>>>>>> 2de7f8466e17e6fa2f0a86bc1f02ee60eefeba18
    end
  end
end

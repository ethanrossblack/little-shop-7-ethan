require 'rails_helper'

RSpec.describe "Admin Invoice Show Page", type: :feature do
  before :each do
    @merchant_1 = Merchant.create!(name: "Bob's Burgers")
    @merchant_2 = Merchant.create!(name: "Kwik-E-Mart")
    
    @customer_1 = Customer.create!(first_name: "Marge", last_name: "Simpson")
    @customer_2 = Customer.create!(first_name: "Joe", last_name: "Swanson")
    @customer_3 = Customer.create!(first_name: "Linda", last_name: "Belcher")

    @invoice_1 = Invoice.create!(customer_id: @customer_1.id, status: 1)
    @invoice_2 = Invoice.create!(customer_id: @customer_1.id, status: 0)
    @invoice_3 = Invoice.create!(customer_id: @customer_2.id, status: 1)
    @invoice_4 = Invoice.create!(customer_id: @customer_2.id, status: 1)
    @invoice_5 = Invoice.create!(customer_id: @customer_3.id, status: 0)
    @invoice_6 = Invoice.create!(customer_id: @customer_3.id, status: 1)

    @item_1 = Item.create!(name: "Burger", description: "Delicious", unit_price: 450, merchant_id: @merchant_1.id)
    @item_2 = Item.create!(name: "Fries", description: "Salty", unit_price: 250, merchant_id: @merchant_1.id)
    @item_3 = Item.create!(name: "Squishee", description: "Slushy", unit_price: 150, merchant_id: @merchant_2.id)
    @item_4 = Item.create!(name: "Hot Dog", description: "Tasty", unit_price: 300, merchant_id: @merchant_2.id)
    @item_5 = Item.create!(name: "Wine", description: "It makes you drink", unit_price: 2000, merchant_id: @merchant_2.id)
    @item_6 = Item.create!(name: "Cheese", description: "It goes well with wine", unit_price: 1375, merchant_id: @merchant_2.id)

    @invoice_item_1 = InvoiceItem.create!(item_id: @item_1.id, invoice_id: @invoice_1.id, quantity: 10, unit_price: 450, status: 1)
    @invoice_item_2 = InvoiceItem.create!(item_id: @item_2.id, invoice_id: @invoice_1.id, quantity: 5, unit_price: 250, status: 1)
    @invoice_item_3 = InvoiceItem.create!(item_id: @item_3.id, invoice_id: @invoice_2.id, quantity: 1, unit_price: 150, status: 1)
    @invoice_item_4 = InvoiceItem.create!(item_id: @item_4.id, invoice_id: @invoice_2.id, quantity: 2, unit_price: 300, status: 1)
    @invoice_item_5 = InvoiceItem.create!(item_id: @item_5.id, invoice_id: @invoice_3.id, quantity: 3, unit_price: 2000, status: 1)
    @invoice_item_6 = InvoiceItem.create!(item_id: @item_6.id, invoice_id: @invoice_3.id, quantity: 4, unit_price: 1375, status: 1)

  end
  # US 33  
  it "I can see each invoice id links to the admin invoice show page" do

    visit admin_invoices_path
    click_link("#{@invoice_1.id}")

    expect(current_path).to eq(admin_invoice_path(@invoice_1))
    expect(page).to have_content(@invoice_1.id)
    expect(page).to have_content(@invoice_1.status.capitalize)
    expect(page).to have_content(@invoice_1.formatted_date)
    expect(page).to have_content(@customer_1.first_name)
    expect(page).to have_content(@customer_1.last_name)
    expect(page).not_to have_content(@customer_2.first_name)
  end

  # US 34
  it "I can see all of the item information on the invoice" do

    visit admin_invoice_path(@invoice_1)

    expect(page).to have_content(@item_1.name)
    expect(page).to have_content(@invoice_item_1.quantity)
    expect(page).to have_content(@invoice_item_1.price_to_currency)
    expect(page).to have_content(@invoice_item_1.status)
    expect(page).to have_content(@item_2.name)
    expect(page).to have_content(@invoice_item_2.quantity)
    expect(page).to have_content(@invoice_item_2.price_to_currency)
    expect(page).to have_content(@invoice_item_2.status)
    expect(page).not_to have_content(@item_3.name)
  end

  # US 35
  it "I can see the total revenue that will be generated from all of the items on the invoice" do
    visit admin_invoice_path(@invoice_1)

    expected_total = @invoice_1.total_revenue_to_currency
    expect(page).to have_content("Total Revenue: #{expected_total}")
  end

  it "I can update the invoice status" do
    visit admin_invoice_path(@invoice_1)

    expect(page).to have_select(:invoice_status, selected: "Completed")
    expect(page).to have_button("Update Invoice Status")

    select("Cancelled", from: :invoice_status)
    click_button("Update Invoice Status")

    expect(current_path).to eq(admin_invoice_path(@invoice_1))
    expect(page).to have_select(:invoice_status, selected: "Cancelled")
  end

  describe "Bulk Discount Project Features" do
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
      @invoice_01 = create(:invoice)
  
      # Invoice Items
      @invoice_item_1_1a = create(:invoice_item, quantity: 10, unit_price: @item_1a.unit_price, item_id: @item_1a.id, invoice_id: @invoice_01.id)
      @invoice_item_1_2a = create(:invoice_item, quantity: 5, unit_price: @item_2a.unit_price, item_id: @item_2a.id, invoice_id: @invoice_01.id)
      @invoice_item_1_3a = create(:invoice_item, quantity: 15, unit_price: @item_3a.unit_price, item_id: @item_3a.id, invoice_id: @invoice_01.id)

      @invoice_item_1_1b = create(:invoice_item, quantity: 2, unit_price: @item_1b.unit_price, item_id: @item_1b.id, invoice_id: @invoice_01.id)
    end

    it "displays the total discounted revenue from this invoice which includes bulk discounts in the calculation" do
      visit admin_invoice_path(@invoice_01)

      save_and_open_page

      expected = ActiveSupport::NumberHelper::number_to_currency(@invoice_01.discounted_revenue_dollars)

      within("#invoice_discounted_revenue") do
        expect(page).to have_content(expected)
      end
    end
  end
end

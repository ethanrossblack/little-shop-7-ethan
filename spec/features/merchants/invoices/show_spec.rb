require "rails_helper"

RSpec.describe "Merchant Invoice Show Page", type: :feature do
  before :each do
    # Customers
    @customer_1 = Customer.create!(first_name: 'Joey', last_name: 'Ondricka')
    @customer_2 = Customer.create!(first_name: 'Cecelia', last_name: 'Osinski')
    @customer_3 = Customer.create!(first_name: 'Mariah', last_name: 'Toy')
    @customer_4 = Customer.create!(first_name: 'Leanna', last_name: 'Braun')

    # Merchants
    @merchant_1 = Merchant.create!(name: 'Schroeder-Jerde')
    @merchant_2 = Merchant.create!(name: 'Rempel and Jones')

    # Items
    # @merchant_1's items
    @item_1 = @merchant_1.items.create!(name: 'Qui Esse', description: 'Nihil autem sit odio inventore deleniti', unit_price: 75107)
    @item_2 = @merchant_1.items.create!(name: 'Autem Minima', description: 'Cumque consequuntur ad', unit_price: 67076)
    @item_3 = @merchant_1.items.create!(name: 'Ea Voluptatum', description: 'Sunt officia eum qui molestiae', unit_price: 32301)
    # @merchant_2's item
    @item_4 = @merchant_2.items.create!(name: 'Nemo Facere', description: 'Sunt eum id eius magni consequuntur delectus veritatis', unit_price: 4291)

    # Invoices
    # @invoice_1 has two items from @merchant_1
    @invoice_1 = @customer_1.invoices.create!(status: 'in progress', created_at: Time.new(2000))
    InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_1.id, quantity: 5, unit_price: 13635, status: 'packaged')
    InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_2.id, quantity: 10, unit_price: 66747, status: 'shipped')
    
    # @invoice_2 has one item from @merchant_1 and one item from @merchant_2
    @invoice_2 = @customer_2.invoices.create!(status: 'completed', created_at: Time.new(2001))
    InvoiceItem.create!(invoice_id: @invoice_2.id, item_id: @item_3.id, quantity: 9, unit_price: 23324, status: 'pending')
    InvoiceItem.create!(invoice_id: @invoice_2.id, item_id: @item_4.id, quantity: 9, unit_price: 76941, status: 'packaged')

    # @invoice 3 has one item from @merchant_2
    @invoice_3 = @customer_3.invoices.create!(status: 'cancelled', created_at: Time.new(2003))
    InvoiceItem.create!(invoice_id: @invoice_3.id, item_id: @item_4.id, quantity: 12, unit_price: 34873, status: 'packaged')
  end

  describe "when I visit a merchant's invoice show page (/merchants/:merchant_id/invoices/:invoice_id)" do
    it "I see that invoice's id and status" do
      visit merchant_invoice_path(@merchant_1, @invoice_1)
      within("div#merchant_invoice_info") do
        expect(page).to have_content("Invoice ##{@invoice_1.id}")
        expect(page).to have_content("Status: In Progress")
      end

      visit merchant_invoice_path(@merchant_1, @invoice_2)
      within("div#merchant_invoice_info") do
        expect(page).to have_content("Invoice ##{@invoice_2.id}")
        expect(page).to have_content("Status: Completed")
      end
    end
    
    it "I see the invoice's created_at date in the format 'Monday, July 18, 2019'" do
      visit merchant_invoice_path(@merchant_1, @invoice_1)
      within("div#merchant_invoice_info") do
        expect(page).to have_content("Created on: Saturday, January 1, 2000")
      end

      visit merchant_invoice_path(@merchant_1, @invoice_2)
      within("div#merchant_invoice_info") do
        expect(page).to have_content("Created on: Monday, January 1, 2001")
      end
    end

    it "I see the customer's first and last name" do
      visit merchant_invoice_path(@merchant_1, @invoice_1)
      within("div#merchant_invoice_customer_info") do
        expect(page).to have_content(@customer_1.first_name)
        expect(page).to have_content(@customer_1.last_name)
      end

      visit merchant_invoice_path(@merchant_1, @invoice_2)
      within("div#merchant_invoice_customer_info") do
        expect(page).to have_content(@customer_2.first_name)
        expect(page).to have_content(@customer_2.last_name)
      end
    end
  end
end

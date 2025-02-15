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
    @invoice1_item_1 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_1.id, quantity: 5, unit_price: 13635, status: 'packaged')
    @invoice1_item_2 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_2.id, quantity: 10, unit_price: 66747, status: 'shipped')
    
    # @invoice_2 has one item from @merchant_1 and one item from @merchant_2
    @invoice_2 = @customer_2.invoices.create!(status: 'completed', created_at: Time.new(2001))
    @invoice2_item_3 = InvoiceItem.create!(invoice_id: @invoice_2.id, item_id: @item_3.id, quantity: 9, unit_price: 23324, status: 'pending')
    @invoice2_item_4 = InvoiceItem.create!(invoice_id: @invoice_2.id, item_id: @item_4.id, quantity: 9, unit_price: 76941, status: 'packaged')

    # @invoice 3 has one item from @merchant_2
    @invoice_3 = @customer_3.invoices.create!(status: 'cancelled', created_at: Time.new(2003))
    @invoice3_item_4 = InvoiceItem.create!(invoice_id: @invoice_3.id, item_id: @item_4.id, quantity: 12, unit_price: 34873, status: 'packaged')
  end

  describe "when I visit a merchant's invoice show page (/merchants/:merchant_id/invoices/:invoice_id)" do
    # ======= START STORY 15 TESTS =======
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
    # ======= END STORY 15 TESTS =======
    
    # ======= START STORY 16 TESTS =======
    it "I see all the merchant's items on the invoice, including the item's name, quantity ordered, price, and invoice item status" do
      visit merchant_invoice_path(@merchant_1, @invoice_1)

      within("div#merchant_invoice_items") do
        # Item 1
        expect(page).to have_content(@item_1.name).once
        expect(page).to have_content(@invoice1_item_1.quantity)
        expect(page).to have_content("$136.35")
        expect(page).to have_content(@invoice1_item_1.status.titleize)
        # Item 2
        expect(page).to have_content(@item_2.name).once
        expect(page).to have_content(@invoice1_item_2.quantity)
        expect(page).to have_content("$667.47")
        expect(page).to have_content(@invoice1_item_2.status.titleize)
      end

      visit merchant_invoice_path(@merchant_2, @invoice_3)

      within("div#merchant_invoice_items") do
        # Item 4
        expect(page).to have_content(@item_4.name).once
        expect(page).to have_content(@invoice3_item_4.quantity)
        expect(page).to have_content("$348.73")
        expect(page).to have_content(@invoice3_item_4.status.titleize)
      end
    end
    
    it "I do not see any information related to items for other merchants" do
      # @invoice_2 has one @item_3, belonging to @merchant_1, and @item_4, one belonging to @merchant_2
      
      visit merchant_invoice_path(@merchant_1, @invoice_2)

      within("div#merchant_invoice_items") do
        # Item 3 belongs to @merchant_1
        expect(page).to have_content(@item_3.name).once
        expect(page).to have_content(@invoice2_item_3.quantity)
        expect(page).to have_content("$233.24")
        expect(page).to have_content(@invoice2_item_3.status.titleize)
        
        expect(page).to_not have_content(@item_4.name)
      end

      visit merchant_invoice_path(@merchant_2, @invoice_2)

      within("div#merchant_invoice_items") do
        # Item 4 belongs to @merchant_2
        expect(page).to have_content(@item_4.name).once
        expect(page).to have_content(@invoice2_item_4.quantity)
        expect(page).to have_content("$769.41")
        expect(page).to have_content(@invoice2_item_4.status.titleize)
        
        expect(page).to_not have_content(@item_3.name)
      end
    end
    # ======= END STORY 16 TESTS =======

    # ======= START STORY 17 TESTS =======
    it "i see the total revenue that will be generated from all of a merchant's items on the invoice" do
      # @invoice_1 has 2 invoice_items on the invoice from @merchant_1
      visit merchant_invoice_path(@merchant_1, @invoice_1)
      
      within("#merchant_invoice_revenue") do
        expect(page).to have_content ("Total Revenue: #{@invoice_1.merchant_revenue_to_currency(@merchant_1.id)}")
      end
      
      # @invoice_1 has 2 invoice_items on the invoice (one from @merchant_1 and another from @merchant_2)
      # This makes sure that it only shows the total revenue of the invoice_items from @merchant_1
      visit merchant_invoice_path(@merchant_1, @invoice_2)
      within("#merchant_invoice_revenue") do
        expect(page).to have_content ("Total Revenue: #{@invoice_2.merchant_revenue_to_currency(@merchant_1.id)}")
      end
      
      # @invoice_1 has 2 invoice_items on the invoice (one from @merchant_1 and another from @merchant_2)
      # This makes sure that it only shows the total revenue of the invoice_items from @merchant_2
      visit merchant_invoice_path(@merchant_2, @invoice_2)
      within("#merchant_invoice_revenue") do
        expect(page).to have_content ("Total Revenue: #{@invoice_2.merchant_revenue_to_currency(@merchant_2.id)}")
      end
    end
    # ======= END STORY 17 TESTS =======
    
    # ======= START STORY 18 TESTS =======
    it "I see that each invoice item status is a select field" do
      visit merchant_invoice_path(@merchant_1, @invoice_1)
      within("td#invoice_item_status_#{@invoice1_item_1.id}") do
        expect(page).to have_select("invoice_item[status]", options: ["Pending", "Packaged", "Shipped"])
      end
    
      within("td#invoice_item_status_#{@invoice1_item_2.id}") do
        expect(page).to have_select("invoice_item[status]", options: ["Pending", "Packaged", "Shipped"])
      end
    end

    it "I see that the invoice item's current status is selected" do
      visit merchant_invoice_path(@merchant_1, @invoice_1)

      within("td#invoice_item_status_#{@invoice1_item_1.id}") do
        expect(page).to have_select("invoice_item[status]", selected: "Packaged")
      end
    
      within("td#invoice_item_status_#{@invoice1_item_2.id}") do
        expect(page).to have_select("invoice_item[status]", selected: "Shipped")
      end
    end

    describe "When I select a new status and click the 'Update Item Status' button next to the select field" do
      it "I am taken back to the merchant invoice show page and see the item's updated status" do
        visit merchant_invoice_path(@merchant_1, @invoice_1)
        
        within("td#invoice_item_status_#{@invoice1_item_1.id}") do
          expect(page).to have_select("invoice_item[status]", selected: "Packaged")
          select("Shipped", from: "invoice_item[status]")
          click_button "Update Item Status"
        end

        expect(current_path).to eq(merchant_invoice_path(@merchant_1, @invoice_1))

        within("td#invoice_item_status_#{@invoice1_item_1.id}") do
          expect(page).to have_select("invoice_item[status]", selected: "Shipped")
        end
      end
    end
    # ======= END STORY 18 TESTS =======

    # === Bulk Discount Tests ===
    describe "Bulk Discount Application" do
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
      
      # === Start Bulk Discount Story 6 Tests ===
      it "displays the total discounted revenue for a merchant from an invoice which includes bulk discounts in the calculation" do
        visit merchant_invoice_path(@merchant_a, @invoice_1)

        expected = ActiveSupport::NumberHelper::number_to_currency(@invoice_1.merchant_discounted_revenue_dollars(@merchant_a.id))

        within("#merchant_invoice_discounted_revenue") do
          expect(page).to have_content(expected)
        end
      end
      # === End Bulk Discount Story 6 Tests ===
      
      # === Start Bulk Discount Story 7 Tests ===
      it "displays next to every discounted invoice item a link to the applied bulk discount show page" do
        visit merchant_invoice_path(@merchant_a, @invoice_1)
        
        within("#invoice_item_#{@invoice_item_1_1a.id}_discount") do
          expect(page).to have_link(href: merchant_bulk_discount_path(@merchant_a, @discount_1a))
        end
        
        within("#invoice_item_#{@invoice_item_1_3a.id}_discount") do
          expect(page).to have_link(href: merchant_bulk_discount_path(@merchant_a, @discount_2a))
        end
      end
      # === End Bulk Discount Story 7 Tests ===
    end
  end
end

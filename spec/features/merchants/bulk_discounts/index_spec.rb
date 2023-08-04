require "rails_helper" 

RSpec.describe "Bulk Discounts Index Page" do
  before :each do
    @merchant = Merchant.create!(name: "Ethan Inc.")

    @discount1 = @merchant.bulk_discounts.create!(discount: 15, quantity: 10)
    @discount2 = @merchant.bulk_discounts.create!(discount: 20, quantity: 15)
    @discount3 = @merchant.bulk_discounts.create!(discount: 25, quantity: 20)

    visit merchant_bulk_discounts_path(@merchant)
  end


  it "lists every bulk discount with its percentage discount and quantity threshold for a merchant" do
    within("#bulk_discount_#{@discount1.id}") do
      expect(page).to have_content("Discount #{@discount1.id}").once
      expect(page).to have_content("#{@discount1.discount}%").once
      expect(page).to have_content(@discount1.quantity).once
    end
    
    within("#bulk_discount_#{@discount2.id}") do
      expect(page).to have_content("Discount #{@discount2.id}").once
      expect(page).to have_content("#{@discount2.discount}%").once
      expect(page).to have_content(@discount2.quantity).once
    end
    
    within("#bulk_discount_#{@discount3.id}") do
      expect(page).to have_content("Discount #{@discount3.id}").once
      expect(page).to have_content("#{@discount3.discount}%").once
      expect(page).to have_content(@discount3.quantity).once
    end
  end

  it "each bulk discount listed includes a link to its show page" do
    save_and_open_page
    expect(page).to have_link(href: merchant_bulk_discount_path(@merchant, @discount1)).once
  
    expect(page).to have_link(href: merchant_bulk_discount_path(@merchant, @discount2)).once
  
    expect(page).to have_link(href: merchant_bulk_discount_path(@merchant, @discount3)).once
  end
end
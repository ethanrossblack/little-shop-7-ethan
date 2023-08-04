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
      expect(page).to have_content("#{@discount1.discount}% off purchases of #{@discount1.quantity} or more items.").once
    end
    
    within("#bulk_discount_#{@discount2.id}") do
      expect(page).to have_content("Discount #{@discount2.id}").once
      expect(page).to have_content("#{@discount2.discount}% off purchases of #{@discount2.quantity} or more items.").once
    end
    
    within("#bulk_discount_#{@discount3.id}") do
      expect(page).to have_content("Discount #{@discount3.id}").once
      expect(page).to have_content("#{@discount3.discount}% off purchases of #{@discount3.quantity} or more items.").once
    end
  end

  it "each bulk discount listed includes a link to its show page" do
    expect(page).to have_link(href: merchant_bulk_discount_path(@merchant, @discount1)).once
  
    expect(page).to have_link(href: merchant_bulk_discount_path(@merchant, @discount2)).once
  
    expect(page).to have_link(href: merchant_bulk_discount_path(@merchant, @discount3)).once
  end

  it "has a link to create a new discount" do
    expect(page).to have_link("Create New Bulk Discount")

    click_link("Create New Bulk Discount")

    expect(current_path).to eq(new_merchant_bulk_discount_path(@merchant))
  end
end

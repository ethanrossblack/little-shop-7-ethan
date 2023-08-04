require "rails_helper"

RSpec.describe "Bulk Discount New Page", type: :feature do
  before :each do
    @merchant = Merchant.create!(name: "Ethan Inc.")

    visit new_merchant_bulk_discount_path(@merchant)
  end
  
  it "has a form to add a new bulk discount" do
    save_and_open_page
    
    within("#new_bulk_discount_form") do
      expect(page).to have_field("Discount")
      expect(page).to have_field("Quantity")
    end
  end

  it "can create a new bulk discount" do
    within("#new_bulk_discount_form") do
      fill_in("Discount", with: "50")
      fill_in("Quantity", with: "30")

      click_button("Create Bulk Discount")
    end

    expect(current_path).to eq(merchant_bulk_discounts_path(@merchant))
    
    expect(page).to have_content("50% off purchases of 30 or more items.").once
  end
end


# As a merchant
# When I visit my bulk discounts index
# Then I see a link to create a new discount
# When I click this link
# Then I am taken to a new page where I see a form to add a new bulk discount
# When I fill in the form with valid data
# Then I am redirected back to the bulk discount index
# And I see my new bulk discount listed
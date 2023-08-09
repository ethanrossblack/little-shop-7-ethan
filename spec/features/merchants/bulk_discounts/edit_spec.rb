require "rails_helper"

RSpec.describe "Bulk Discount Edit Page", type: :feature do
  before :each do
    @merchant = Merchant.create!(name: "Ethan Inc.")
    @discount = @merchant.bulk_discounts.create!(discount: 15, quantity: 10)

    visit edit_merchant_bulk_discount_path(@merchant, @discount)
  end

  it "pre-populates the bulk discount's current attributes in the form" do
    within("#new_bulk_discount_form") do
      expect(page).to have_field("Discount", with: @discount.discount)
      expect(page).to have_field("Quantity", with: @discount.quantity)
    end
  end

  describe "when I change any/all of the information and click submit" do
    before :each do
      fill_in("Discount", with: "50")
      fill_in("Quantity", with: "30")

      click_button("Edit Bulk Discount")
    end

    it "then I am redirected to the bulk discount's show page" do
      expect(current_path).to eq(merchant_bulk_discount_path(@merchant, @discount))
    end

    it "and I see that the discount's attributes have been updated" do
      @discount.reload
      
      within(".bulk_discount_quantity") do
        expect(page).to have_content("30").once
      end
  
      within(".bulk_discount_percentage") do
        expect(page).to have_content("50").once
      end
    end
  end
end

require "rails_helper"

RSpec.describe "Bulk Discount Show Page", type: :feature do
  before :each do
    @merchant = Merchant.create!(name: "Ethan Inc.")
    @discount = @merchant.bulk_discounts.create!(discount: 15, quantity: 10)

    visit merchant_bulk_discount_path(@merchant, @discount)
  end

  it "displays the discount's quantity threshold and percentage discount" do
    within(".bulk_discount_quantity") do
      expect(page).to have_content(@discount.quantity).once
    end

    within(".bulk_discount_percentage") do
      expect(page).to have_content(@discount.discount).once
    end
  end
end

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

  it "has a link to edit the bulk discount that tales you to a new page with a form to edit the bulk discount" do
    expect(page).to have_link("Edit Bulk Discount")

    click_link("Edit Bulk Discount")

    expect(current_path).to eq(edit_merchant_bulk_discount_path(@merchant, @discount))
  end
end

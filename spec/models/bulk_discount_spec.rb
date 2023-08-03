require "rails_helper"

RSpec.describe BulkDiscount, type: :model do
  describe "Relationships" do
    it {should belong_to :merchant}
  end

  describe "Validations" do
    it {should validate_presence_of :discount}
    it {should validate_presence_of :quantity}
  end
end
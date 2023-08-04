class MerchantBulkDiscountsController < ApplicationController
  before_action :set_merchant, only: [:index]
  
  def index
  end

  private

  def set_merchant
    @merchant = Merchant.find(params[:merchant_id])
  end
end
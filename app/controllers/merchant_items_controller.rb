class MerchantItemsController < ApplicationController
  def index
    @merchant = Merchant.find(params[:merchant_id])
    @items = @merchant.items.all
  end

  def show
    @merchant = Merchant.find(params[:merchant_id])
    @item = @merchant.items.find(params[:id])
  end
end
class MerchantBulkDiscountsController < ApplicationController
  before_action :set_merchant, only: [:index, :new, :create]
  before_action :set_merchant_and_bulk_discount, only: [:destroy, :show, :edit, :update]
  
  def index
    @holidays = HolidayService.new.get_next_3_holidays
  end

  def new
    @bulk_discount = @merchant.bulk_discounts.new
  end

  def create
    bulk_discount = @merchant.bulk_discounts.new(bulk_discount_params)
    if bulk_discount.save
      flash[:success] = "Bulk Discount created successfully."
      redirect_to merchant_bulk_discounts_path
    else
      flash[:alert] = "Error: #{error_message(bulk_discount.errors)}."
      redirect to new_merchant_bulk_discount_path
    end
  end

  def edit
  end

  def update
    if @bulk_discount.update(bulk_discount_params)
      redirect_to merchant_bulk_discount_path(@merchant, @bulk_discount)
      flash[:success] = "Bulk Discount Successfully Updated"
    else
      redirect_to edit_merchant_bulk_discount_path(@merchant, @bulk_discount)
      flash[:alert] = "Error: #{error_message(@bulk_discount.errors)}"
    end
  end

  def destroy
    BulkDiscount.destroy(@bulk_discount.id)
    flash[:alert] = "Discount #{@bulk_discount.id} destroyed."
    redirect_to merchant_bulk_discounts_path(@merchant)
  end

  def show

  end

  private
    def set_merchant
      @merchant = Merchant.find(params[:merchant_id])
    end

    def bulk_discount_params
      params.require(:bulk_discount).permit(:discount, :quantity)
    end

    def set_merchant_and_bulk_discount
      @merchant = Merchant.find(params[:merchant_id])
      @bulk_discount = BulkDiscount.find(params[:id])
    end
end
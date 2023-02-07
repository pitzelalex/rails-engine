class Api::V1::MerchantsController < ApplicationController
  def index
    render json: MerchantSerializer.new(Merchant.all)
  end

  def show
    render json: MerchantSerializer.new(merchant)
  end

  private

  def merchant
    Merchant.find(params[:id])
  end
end

class Api::V1::Merchants::FindController < ApplicationController
  def index
    merchants = Merchant.search_name(params[:name])
    render json: MerchantSerializer.new(merchants)
  end
end

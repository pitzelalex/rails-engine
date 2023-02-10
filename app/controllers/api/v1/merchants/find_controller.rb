class Api::V1::Merchants::FindController < ApplicationController
  def index
    if params.keys.include?('name')
      if params[:name].nil? || params[:name] == ''
        send_error("Name Can't be empty", 400)
      else
        merchants = Merchant.search_name(params[:name])
        render json: MerchantSerializer.new(merchants)
      end
    else
      send_error('Must include 1 valid search parameter', 400)
    end
  end

  private

  def send_error(message, status)
    render json: SimpleErrorSerializer.new(message, status: status), status: status
  end
end

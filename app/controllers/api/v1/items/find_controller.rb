class Api::V1::Items::FindController < ApplicationController
  def show
    if params[:min_price] || params[:max_price]
      if params[:name]
        render json: { errors: [
          {
            message: "Can't search by name and price"
          }
        ] }, status: 400
      elsif params[:max_price].to_f.negative?
        negative_price_error
      elsif params[:min_price].to_f.negative?
        negative_price_error
      else
        item = Item.search_price(price_range).first
        if item
          render json: ItemSerializer.new(item)
        else
          render json: { data: {} }
        end
      end
    elsif params[:name]
      item = Item.search_name(params[:name]).first
      if item
        render json: ItemSerializer.new(item)
      else
        # render json: ItemSerializer.new(Item.new)
        render json: { data: {} }
      end
    end
  end

  private

  def price_range
    params.permit(:max_price, :min_price)
  end

  def negative_price_error
    render json: { errors: [
      {
        message: "Price can't be negative"
      }
    ] }, status: 400
  end
end

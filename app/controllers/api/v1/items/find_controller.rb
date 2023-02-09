class Api::V1::Items::FindController < ApplicationController
  def show
    expected = ['name', 'max_price', 'min_price']
    if (params.keys & expected).any? # Checks if at least 1 param was passed
      if (params.keys & expected.last(2)).any? # Checks if either price params passed
        if params.keys.include?('name') # Checks if attempting to search by price and name
          send_error("Can't search by name and price", 400)
        elsif (params[:min_price].nil? and params.keys.include?('min_price')) || (params[:max_price].nil? and params.keys.include?('max_price')) # Checks if either price param is empty
          send_error("Price Can't be empty", 400)
        elsif params[:max_price].to_f.negative? or params[:min_price].to_f.negative? # Checks if either price param is a negative number
          send_error("Price can't be negative", 400)
        else
          item = Item.search_price(price_range).first
          if item
            render json: ItemSerializer.new(item)
          else
            render json: { data: {} }
          end
        end
      elsif params.keys.include?('name') # Checks if name param was passed
        if params[:name].nil? # Checks if name param is empty
          send_error("Name Can't be empty", 400)
        else
          item = Item.search_name(params[:name]).first
          if item
            render json: ItemSerializer.new(item)
          else
            render json: { data: {} }
          end
        end
      end
    else
      send_error('Must include 1 valid search parameter', 400)
    end
  end

  private

  def price_range
    params.permit(:max_price, :min_price)
  end

  def send_error(message, code)
    render json: SimpleErrorSerializer.new(message), status: code
  end
end

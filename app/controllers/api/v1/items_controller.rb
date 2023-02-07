class Api::V1::ItemsController < ApplicationController
  def index
    render json: ItemSerializer.new(Item.all)
  end

  def show
    item = Item.find(params[:id])
    render json: ItemSerializer.new(item)
  end

  def create
    render json: ItemSerializer.new(Item.create!(item_params)), status: 201
  end

  def update
    # require 'pry'; binding.pry if item_params[:merchant_id] == 999999999999
    # item = Item.update(params[:id], item_params)
    item = Item.find(params[:id])
    if item.update(item_params)
      render json: ItemSerializer.new(item)
    else
      render json: item.errors, status: 404
    end
  end

  def destroy
    @item = Item.find(params[:id])
    destroy_invoices
    @item.destroy
  end

  private

  def item_params
    params.require(:item).permit(:name, :description, :unit_price, :merchant_id)
  end

  def destroy_invoices
    @item.invoices.each do |invoice|
      invoice.destroy if invoice.items.include?(@item) && invoice.items.count == 1
    end
  end
end

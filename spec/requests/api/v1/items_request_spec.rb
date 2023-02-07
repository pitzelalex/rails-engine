require 'rails_helper'

describe 'Items API' do
  it 'sends a list of items' do
    create_list(:merchant_with_items, 3, num: 5)

    get '/api/v1/items'

    expect(response).to be_successful

    items = JSON.parse(response.body, symbolize_names: true)

    expect(items).to have_key(:data)
    expect(items[:data]).to be_an Array
    expect(items[:data].count).to eq(15)

    items[:data].each do |i|
      expect(i).to have_key(:id)
      expect(i[:id]).to be_a String
      expect(i).to have_key(:attributes)
      expect(i[:attributes]).to have_key(:name)
      expect(i[:attributes]).to have_key(:description)
      expect(i[:attributes]).to have_key(:unit_price)
      expect(i[:attributes]).to have_key(:merchant_id)

      expect(i[:attributes][:name]).to be_a String
      expect(i[:attributes][:description]).to be_a String
      expect(i[:attributes][:unit_price]).to be_a Float
      expect(i[:attributes][:merchant_id]).to be_an Integer
    end
  end

  it 'sends a list of items' do
    item1 = create(:item)
    item2 = create(:item)

    get "/api/v1/items/#{item1.id}"

    expect(response).to be_successful

    item = JSON.parse(response.body, symbolize_names: true)

    expect(item).to have_key(:data)
    expect(item[:data]).to be_a Hash
    expect(item[:data]).to have_key(:id)
    expect(item[:data][:id]).to be_a String
    expect(item[:data]).to have_key(:attributes)
    expect(item[:data][:attributes]).to be_a Hash
    expect(item[:data][:attributes]).to have_key(:name)
    expect(item[:data][:attributes]).to have_key(:description)
    expect(item[:data][:attributes]).to have_key(:unit_price)
    expect(item[:data][:attributes]).to have_key(:merchant_id)

    expect(item[:data][:attributes][:name]).to be_a String
    expect(item[:data][:attributes][:description]).to be_a String
    expect(item[:data][:attributes][:unit_price]).to be_a Float
    expect(item[:data][:attributes][:merchant_id]).to be_an Integer
  end
end

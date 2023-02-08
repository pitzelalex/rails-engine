require 'rails_helper'

describe 'Items Search API' do
  it 'sends an item that best matches the search' do
    i1 = create(:item, name: 'Brown Cow', description: 'none')
    i2 = create(:item, name: 'Doorhinge', description: 'Stuck in escrow')
    i3 = create(:item, name: 'A whole Bitcoin', description: 'DREAM ON!')
    i4 = create(:item, name: 'A Grown Pig', description: "It still can't fly")

    get '/api/v1/items/find?name=RoW'

    expect(response).to be_successful

    item = JSON.parse(response.body, symbolize_names: true)

    expect(item[:data][:id]).to eq(i4.id.to_s)
    expect(item[:data][:type]).to eq('item')
    expect(item[:data][:attributes][:name]).to eq(i4.name)
    expect(item[:data][:attributes][:description]).to eq(i4.description)
    expect(item[:data][:attributes][:unit_price]).to eq(i4.unit_price)
    expect(item[:data][:attributes][:merchant_id]).to eq(i4.merchant_id)

    get '/api/v1/items/find?name=asdgasdfsd'

    expect(response).to be_successful

    item = JSON.parse(response.body, symbolize_names: true)

    expect(item[:attributes]).to be nil
  end

  it 'searches by price' do
    i1 = create(:item, name: 'Brown Cow', description: 'brown', unit_price: 150)
    i2 = create(:item, name: 'Doorhinge', description: 'Stuck in escrow', unit_price: 300)
    i3 = create(:item, name: 'A whole Bitcoin', description: 'DREAM ON!', unit_price: 750)
    i4 = create(:item, name: 'A Grown Pig', description: "It still can't fly", unit_price: 1000)

    get '/api/v1/items/find?max_price=300'

    expect(response).to be_successful

    item = JSON.parse(response.body, symbolize_names: true)

    expect(item[:data][:id]).to eq(i1.id.to_s)

    get '/api/v1/items/find?min_price=300'

    expect(response).to be_successful

    item = JSON.parse(response.body, symbolize_names: true)

    expect(item[:data][:id]).to eq(i4.id.to_s)

    get '/api/v1/items/find?min_price=151&max_price=750'

    expect(response).to be_successful

    item = JSON.parse(response.body, symbolize_names: true)

    expect(item[:data][:id]).to eq(i3.id.to_s)
  end

  it "can't search by invalid prices" do
    get '/api/v1/items/find?max_price=-300'

    expect(response).not_to be_successful

    error = JSON.parse(response.body, symbolize_names: true)

    expect(error[:errors][0][:message]).to eq("Price can't be negative")

    get '/api/v1/items/find?min_price=-300'

    expect(response).not_to be_successful

    error = JSON.parse(response.body, symbolize_names: true)

    expect(error[:errors][0][:message]).to eq("Price can't be negative")
  end

  it "can't search by price and name" do
    get '/api/v1/items/find?name=RoW&max_price=150'

    expect(response).not_to be_successful

    error = JSON.parse(response.body, symbolize_names: true)

    expect(error[:errors][0][:message]).to eq("Can't search by name and price")
  end
end

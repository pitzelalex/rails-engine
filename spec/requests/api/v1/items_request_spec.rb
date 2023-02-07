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
      expect(i).to have_key(:type)
      expect(i[:type]).to be_a String
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
    create(:item)

    get "/api/v1/items/#{item1.id}"

    expect(response).to be_successful

    item = JSON.parse(response.body, symbolize_names: true)

    expect(item).to have_key(:data)
    expect(item[:data]).to be_a Hash
    expect(item[:data]).to have_key(:id)
    expect(item[:data][:id]).to be_a String
    expect(item[:data]).to have_key(:type)
    expect(item[:data][:type]).to be_a String
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

  it 'can create a new item' do
    m = create(:merchant)
    item_params = {
      name: 'Super Awesome Item',
      description: 'This item has a sick description. It truy is super awesome',
      unit_price: 420.69,
      merchant_id: m.id
    }

    headers = { 'CONTENT_TYPE' => 'application/json' }

    post '/api/v1/items', headers: headers, params: JSON.generate(item: item_params)
    created_item = Item.last

    expect(response).to be_successful
    expect(created_item.name).to eq(item_params[:name])
    expect(created_item.description).to eq(item_params[:description])
    expect(created_item.unit_price).to eq(item_params[:unit_price])
    expect(created_item.merchant_id).to eq(item_params[:merchant_id])
  end

  it 'can update an existing item' do
    id = create(:item).id
    previous_name = Item.last.name
    item_params = { name: 'Cool New Name' }
    headers = { 'CONTENT_TYPE': 'application/json' }

    patch "/api/v1/items/#{id}", headers: headers, params: JSON.generate({ item: item_params })
    item = Item.find(id)

    expect(response).to be_successful
    expect(item.name).not_to eq(previous_name)
    expect(item.name).to eq('Cool New Name')

    item_params = { merchant_id: 9999999999 }
    headers = { 'CONTENT_TYPE': 'application/json' }

    patch "/api/v1/items/#{id}", headers: headers, params: JSON.generate({ item: item_params })

    expect(response).to_not be_successful

    # todo: Update expectations and format error json
  end

  it 'can destroy an item' do
    item = create(:item)

    expect(Item.count).to eq(1)

    delete "/api/v1/items/#{item.id}"

    expect(response).to be_successful
    expect(Item.count).to eq(0)
    expect { Item.find(item.id) }.to raise_error(ActiveRecord::RecordNotFound)
  end

  it 'when it destroys an item it destroys any invoices where it was the only item' do
    merchant = create(:merchant)
    item1 = create(:item, merchant: merchant)
    item2 = create(:item, merchant: merchant)
    invoice1 = create(:invoice, merchant: merchant)
    invoice2 = create(:invoice, merchant: merchant)
    create(:invoice_item, item: item1, invoice: invoice1)
    create(:invoice_item, item: item1, invoice: invoice2)
    create(:invoice_item, item: item2, invoice: invoice2)

    expect(Invoice.count).to eq(2)
    expect(InvoiceItem.count).to eq(3)

    delete "/api/v1/items/#{item1.id}"

    expect(response).to be_successful

    expect(Invoice.count).to eq(1)
    expect(InvoiceItem.count).to eq(1)

    expect { Invoice.find(invoice1.id) }.to raise_error(ActiveRecord::RecordNotFound)
  end
end

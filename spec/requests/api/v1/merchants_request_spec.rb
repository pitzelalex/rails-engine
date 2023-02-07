require 'rails_helper'

describe 'Merchants API' do
  it 'sends a list of merchants' do
    create_list(:merchant, 3)

    get '/api/v1/merchants'

    expect(response).to be_successful

    merchants = JSON.parse(response.body, symbolize_names: true)

    expect(merchants).to have_key(:data)
    expect(merchants[:data]).to be_an Array
    expect(merchants[:data].count).to eq(3)

    merchants[:data].each do |m|
      expect(m).to have_key(:attributes)
      expect(m[:attributes]).to have_key(:name)

      expect(m[:attributes][:name]).to be_a String
    end
  end

  it 'sends an empty array if there are no merchants' do
    get '/api/v1/merchants'

    expect(response).to be_successful

    merchants = JSON.parse(response.body, symbolize_names: true)

    expect(merchants).to have_key(:data)
    expect(merchants[:data]).to be_an Array
    expect(merchants[:data].count).to eq(0)
  end

  it 'sends a single merchant' do
    m1 = create(:merchant)
    m2 = create(:merchant)

    get "/api/v1/merchants/#{m1.id}"

    expect(response).to be_successful

    merchant = JSON.parse(response.body, symbolize_names: true)

    expect(merchant).to have_key(:data)
    expect(merchant[:data]).to be_a Hash
    expect(merchant[:data]).to have_key(:attributes)
    expect(merchant[:data][:attributes]).to be_a Hash
    expect(merchant[:data][:attributes]).to have_key(:name)
    expect(merchant[:data][:attributes][:name]).to be_a String

    get "/api/v1/merchants/#{m2.id}"

    expect(response).to be_successful

    get "/api/v1/merchants/#{m2.id + 1}"

    error = JSON.parse(response.body, symbolize_names: true)

    expect(response).to_not be_successful

    expect(error).to have_key(:errors)
    expect(error[:errors]).to be_an Array
    expect(error[:errors][0]).to be_a Hash
    expect(error[:errors][0]).to have_key(:message)
    expect(error[:errors][0]).to have_key(:code)
    expect(error[:errors][0][:message]).to be_a String
    expect(error[:errors][0][:code]).to be_a String
  end

  it 'sends a list of a merchants items' do
    m1 = create(:merchant_with_items, num: 5)
    m2 = create(:merchant_with_items, num: 5)
    m3 = create(:merchant)

    get "/api/v1/merchants/#{m1.id}/items"

    expect(response).to be_successful

    items = JSON.parse(response.body, symbolize_names: true)

    expect(items).to have_key(:data)
    expect(items[:data]).to be_an Array
    expect(items[:data].count).to eq(5)
    items[:data].each do |i|
      expect(i).to have_key(:id)
      expect(i[:id]).to be_a String
      expect(i).to have_key(:attributes)
      expect(i[:attributes]).to be_a Hash
      expect(i[:attributes].count).to eq(4)
      expect(i[:attributes]).to have_key(:name)
      expect(i[:attributes]).to have_key(:description)
      expect(i[:attributes]).to have_key(:unit_price)
      expect(i[:attributes]).to have_key(:merchant_id)
      expect(i[:attributes][:name]).to be_a String
      expect(i[:attributes][:description]).to be_a String
      expect(i[:attributes][:unit_price]).to be_a Float
      expect(i[:attributes][:merchant_id]).to be_an Integer
    end

    get "/api/v1/merchants/#{m3.id}/items"

    expect(response).to be_successful

    items = JSON.parse(response.body, symbolize_names: true)

    expect(items[:data].count).to eq(0)
  end
end

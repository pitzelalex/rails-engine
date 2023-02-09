require 'rails_helper'

describe 'Merchants Search API' do
  it 'sends a list of Merchants that best matches the search' do
    merchant_names = ['Amazon', 'Apple', 'New Egg', 'Canada Computers', 'Best Buy', 'Intel', 'Advanced Micro Devices', 'Micro Center', 'Micron', 'Canadian Tire']
    merchants = merchant_names.map { |name| create(:merchant, name: name) }

    get '/api/v1/merchants/find?name=mIcR'

    expect(response).to be_successful

    found_merchants = JSON.parse(response.body, symbolize_names: true)

    expect(found_merchants[:data][0][:id]).to eq(merchants[6].id.to_s)
    expect(found_merchants[:data][0][:type]).to eq('merchant')
    expect(found_merchants[:data][0][:attributes][:name]).to eq(merchants[6].name)
    expect(found_merchants[:data][2][:id]).to eq(merchants[8].id.to_s)
    expect(found_merchants[:data][2][:type]).to eq('merchant')
    expect(found_merchants[:data][2][:attributes][:name]).to eq(merchants[8].name)
  end
end

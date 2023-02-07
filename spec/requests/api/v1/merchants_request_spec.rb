require 'rails_helper'

describe 'Merchants API' do
  it 'sends a list of merchants' do
    create_list(:merchant, 3)

    get '/api/v1/merchants'

    expect(response).to be_successful

    merchants = JSON.parse(response.body, symbolize_names: true)

    expect(merchants).to have_key(:data)
    expect(merchants[:data].count).to eq(3)

    merchants[:data].each do |m|
      expect(m).to have_key(:attributes)
      expect(m[:attributes]).to have_key(:name)

      expect(m[:attributes][:name]).to be_a String
    end
  end
end

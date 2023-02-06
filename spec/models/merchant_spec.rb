require 'rails_helper'

RSpec.describe Merchant, type: :model do
  describe 'relationships' do
    # it { should have_many(:viewing_parties).with_foreign_key('host_id') } 
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }
  end
end
require 'rails_helper'

RSpec.describe Invoice, type: :model do
  describe 'relationships' do
    it { should have_many(:invoice_items).dependent(:delete_all) }
    it { should have_many(:items).through(:invoice_items) }
  end
end

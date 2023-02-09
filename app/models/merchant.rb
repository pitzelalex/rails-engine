class Merchant < ApplicationRecord
  has_many :items
  has_many :invoices
  validates :name, presence: true

  def self.search_name(search_params)
    self.where('name ILIKE ?', "%#{search_params}%").order(:name)
  end
end

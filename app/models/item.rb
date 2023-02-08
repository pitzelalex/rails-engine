class Item < ApplicationRecord
  belongs_to :merchant
  has_many :invoice_items, dependent: :delete_all
  has_many :invoices, through: :invoice_items
  validates_presence_of :name, :description, :unit_price
  validates_numericality_of :unit_price
  # validate :validate_merchant_id

  private

  # def validate_merchant_id
  #   errors.add(:merchant_id, 'invalid id') unless Merchant.exists?(self.merchant_id)
  # end
end

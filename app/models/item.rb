class Item < ApplicationRecord
  validates_presence_of :name, :description, :unit_price
  validates_numericality_of :unit_price

  belongs_to :merchant
  has_many :invoice_items, dependent: :delete_all
  has_many :invoices, through: :invoice_items
end

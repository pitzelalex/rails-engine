class Item < ApplicationRecord
  belongs_to :merchant
  has_many :invoice_items, dependent: :delete_all
  has_many :invoices, through: :invoice_items
  validates_presence_of :name, :description, :unit_price
  validates_numericality_of :unit_price

  def self.search_name(search_params)
    self.where('name ILIKE ? OR description ILIKE ?', "%#{search_params}%", "%#{search_params}%").order(:name)
  end

  def self.search_price(range)
    min = range[:min_price].to_f
    max = checked_max(range[:max_price])

    self.where(unit_price: min..max).order(:name)
  end

  def self.checked_max(max)
    if max
      max.to_f
    else
      self.maximum(:unit_price)
    end
  end
end

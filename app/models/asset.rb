class Asset < ApplicationRecord
  belongs_to :creator
  has_many :purchases
  has_many :customers, through: :purchases

  validates :title, presence: true
  validates :file_url, presence: true
  validates :price, numericality: { greater_than_or_equal_to: 0 }
end

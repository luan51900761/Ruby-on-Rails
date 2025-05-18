class Purchase < ApplicationRecord
  belongs_to :customer
  belongs_to :asset

  validates :purchase_date, presence: true
end

class Customer < ApplicationRecord
  belongs_to :user
  has_many :purchases
  has_many :assets, through: :purchases
end

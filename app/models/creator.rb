class Creator < ApplicationRecord
  belongs_to :user
  has_many :assets

  def total_earnings
    assets.joins(:purchases).sum(:price)
  end
end

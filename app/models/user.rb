class User < ApplicationRecord
  has_secure_password
  has_one :creator
  has_one :customer
  validates :email, presence: true, uniqueness: true
  validates :role, inclusion: { in: ['admin', 'creator', 'customer'] }
end

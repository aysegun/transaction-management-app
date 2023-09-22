class Client < ApplicationRecord
  has_many :expenses
  has_many :payments
end

require 'bigdecimal'

class Client < ApplicationRecord
  has_many :expenses
  has_many :payments

  attribute :balance, :decimal, precision: 10, scale: 2, default: 0.0

  def credit(amount)
    self.balance += BigDecimal(amount.to_s)
    save
  end

  def debit(amount)
    if self.balance >= BigDecimal(amount.to_s)
      self.balance -= BigDecimal(amount.to_s)
      save
    else
      errors.add(:balance, "Insufficient balance")
      false
    end
  end
end

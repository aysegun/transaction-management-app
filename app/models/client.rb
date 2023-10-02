require 'bigdecimal'

class Client < ApplicationRecord
  has_many :expenses
  has_many :payments
  validates :first_name, presence: true
  validates :last_name, presence: true

  attribute :balance, :decimal, precision: 10, scale: 2, default: 0.0

  def credit(amount)
    self.balance += BigDecimal(amount.to_s) if valid_numeric?(amount)
    save
  end

  def debit(amount)
    amount_as_decimal = BigDecimal(amount.to_s) if valid_numeric?(amount)
    if amount_as_decimal && self.balance >= amount_as_decimal
      self.balance -= amount_as_decimal
      save
    else
      errors.add(:balance, "Insufficient balance")
      false
    end
    # if self.balance >= BigDecimal(amount.to_s) && valid_numeric?(amount)
    #   self.balance -= BigDecimal(amount.to_s)
    #   save
    # else
    #   errors.add(:balance, "Insufficient balance")
    #   false
    # end
  end

  private

  def valid_numeric?(value)
    Float(value)
    true
  rescue ArgumentError, TypeError
    false
  end
end

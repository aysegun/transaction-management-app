
require 'bigdecimal'

class Client < ApplicationRecord
  has_many :expenses
  has_many :payments

  validates :first_name, presence: true
  validates :last_name, presence: true

  before_create :set_default_balance

  def credit(amount)
    amount_as_decimal = BigDecimal(amount.to_s) if valid_numeric?(amount)
    self.balance += amount_as_decimal if amount_as_decimal
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
  end

  private

  def valid_numeric?(value)
    Float(value)
    true
  rescue ArgumentError, TypeError
    false
  end

  def set_default_balance
    self.balance ||= BigDecimal('0.0')
  end
end

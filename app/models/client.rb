class Client < ApplicationRecord
  has_many :expenses
  has_many :payments

  def credit(amount)
    self.balance ||= 0  # Initialize balance to 0 if it's nil
    self.balance += amount
    save
  end

  def debit(amount)
    self.balance ||= 0  # Initialize balance to 0 if it's nil

    # Ensure sufficient balance before debiting
    if self.balance >= amount
      self.balance -= amount
      save
    else
      errors.add(:balance, 'Insufficient balance')
      false
    end
  end
end

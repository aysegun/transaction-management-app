class TransactionsController < ApplicationController

  def create_expense
    client = Client.find(params[:client_id])
    amount = params[:amount]

    ActiveRecord::Base.transaction do
      client.credit(amount)
      Expense.create(client: client, amount: amount)
    end

    render json: { message: 'Expense created successfully' }, status: :ok
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'User or client not found' }, status: :not_found
  rescue ActiveRecord::RecordInvalid => e
    render json: { error: e.message }, status: :unprocessable_entity
  end

  def create_payment
    client = Client.find(params[:client_id])
    amount = params[:amount]

    ActiveRecord::Base.transaction do
      client.debit(amount)
      Payment.create(client: client, amount: amount)
    end

    render json: { message: 'Payment created successfully' }, status: :ok
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'User or client not found' }, status: :not_found
  rescue ActiveRecord::RecordInvalid => e
    render json: { error: e.message }, status: :unprocessable_entity
  end
end

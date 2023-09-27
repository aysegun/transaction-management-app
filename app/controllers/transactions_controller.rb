class TransactionsController < ApplicationController

  def new
    @client = Client.find(params[:client_id])
    @expense = Expense.new
    @payment = Payment.new
  end

  #show method is not working
  def show
    @expense = Expense.find(params[:client_id])
    @payment = Payment.find(params[:client_id])
  end

  def index
    @client = Client.find(params[:client_id])
    @transactions = @client.expenses + @client.payments
  end

  def create_expense
    client = Client.find(params[:client_id])
    amount = params[:amount]

    ActiveRecord::Base.transaction do
      client.credit(amount)
      Expense.create(client: client, amount: amount)
    end

    redirect_to client_path(client)
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

    redirect_to client_path(client)
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'User or client not found' }, status: :not_found
  rescue ActiveRecord::RecordInvalid => e
    render json: { error: e.message }, status: :unprocessable_entity
  end
end

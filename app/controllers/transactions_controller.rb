class TransactionsController < ApplicationController

  def new
    @client = Client.find(params[:client_id])
    if params[:transaction_type] == 'expense'
      @expense = Expense.new
      @expense.amount = 0 # Set a default value for amount
      @expense.date = Date.current # Set a default value for date
    else
      @payment = Payment.new
      @payment.amount = 0 # Set a default value for amount
      @payment.date = Date.current # Set a default value for date
    end
  end

  def show
    @client = Client.find(params[:client_id])
    transaction_type = params[:transaction_type]

    if transaction_type == 'expense'
      @transaction = Expense.find(params[:id])
    elsif transaction_type == 'payment'
      @transaction = Payment.find(params[:id])
    else
      render json: { error: 'Invalid transaction type' }, status: :unprocessable_entity
    end
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'Transaction not found' }, status: :not_found
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
      Expense.create!(client: client, amount: amount)
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
      Payment.create!(client: client, amount: amount)
    end

    redirect_to client_path(client)
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'User or client not found' }, status: :not_found
  rescue ActiveRecord::RecordInvalid => e
    render json: { error: e.message }, status: :unprocessable_entity
  end

  def destroy
    transaction_type = params[:transaction_type]
    transaction_id = params[:id]

    begin
      transaction = transaction_type == 'expense' ? Expense.find(transaction_id) : Payment.find(transaction_id)
      client = transaction.client

      ActiveRecord::Base.transaction do
        client.credit(transaction.amount) if transaction_type == 'expense'
        client.debit(transaction.amount) if transaction_type == 'payment'
        transaction.destroy
      end

      redirect_to client_path(client)
    rescue ActiveRecord::RecordNotFound
      render json: { error: 'Transaction not found' }, status: :not_found
    rescue ActiveRecord::RecordInvalid => e
      render json: { error: e.message }, status: :unprocessable_entity
    end
  end
end

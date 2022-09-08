class TransactionsController < ApplicationController
  # before_action :authenticate_user!
  # before_action :set_user_password_amount, only: %i[save_deposit save_withdraw save_transfer_between_accounts]

  def index
    @transaction = Transaction.new(user: current_user)
    authorize @transaction
    if params[:init_date].present? && params[:final_date].present?
      sql_query = '(user_id = :query OR destination_account_id = :query) AND created_at >= :init_date AND created_at <= :final_date'
      init_date = DateTime.parse(params[:init_date])
      final_date = DateTime.parse("#{params[:final_date]} 23:59:59")
      @transactions = Transaction.where(sql_query, query: current_user.id, init_date:, final_date:).order(:created_at)
    elsif params[:init_date].present? && params[:final_date] == ""
      sql_query = '(user_id = :query OR destination_account_id = :query) AND created_at >= :init_date'
      init_date = DateTime.parse(params[:init_date])

      @transactions = Transaction.where(sql_query, query: current_user.id, init_date:).order(:created_at)
    elsif params[:init_date] == "" && params[:final_date].present?
      sql_query = '(user_id = :query OR destination_account_id = :query) AND created_at <= :final_date'
      final_date = DateTime.parse("#{params[:final_date]} 23:59:59")

      @transactions = Transaction.where(sql_query, query: current_user.id, final_date:).order(:created_at)
    else
      sql_query = 'user_id = :query OR destination_account_id = :query'

      @transactions = Transaction.where(sql_query, query: current_user.id).order(:created_at)
    end
  end

  def deposit
    @user = current_user
    @transaction = Transaction.new
    authorize @transaction
  end

  def save_deposit
    @user = current_user
    password = transaction_params[:password]
    amount = transaction_params[:amount].to_f
    new_balance = @user.balance + amount
    @transaction = Transaction.new(transaction_type: 'Depósito', amount:, user: @user,
                                   old_balance: @user.balance, new_balance:)

    authorize @transaction
    if current_user.valid_password?(password)

      @user.balance = new_balance
      if @transaction.save && @user.save
        redirect_to root_path, notice: 'Depósito realizado com sucesso'
      else
        redirect_to deposit_path(current_user), notice: "Falha ao salvar"
      end
    else
      redirect_to deposit_path(current_user), notice: "Senha incorreta"
    end
  end

  def withdraw
    @user = current_user
    @transaction = Transaction.new
    authorize @transaction
  end

  def save_withdraw
    @transaction = Transaction.new
    @user = current_user
    password = transaction_params[:password]
    amount = transaction_params[:amount].to_f
    new_balance = @user.balance - amount
    @transaction = Transaction.new(transaction_type: 'Saque', amount:, user: @user,
                                   old_balance: @user.balance, new_balance:)
    authorize @transaction
    if amount <= @user.balance

      if current_user.valid_password?(password)
        @user.balance = new_balance
        if @transaction.save && @user.save
          redirect_to root_path, notice: 'Saque realizado com sucesso'
        else
          redirect_to withdraw_path(current_user), notice: "Falha ao salvar"
        end
      else
        redirect_to withdraw_path(current_user), notice: "Senha incorreta"
      end
    else
      redirect_to withdraw_path(current_user), notice: "Saldo insuficiente"
    end
  end

  def transfer_between_accounts
    @user = current_user
    @transaction = Transaction.new
    @destination_account = User.new
    authorize @transaction
  end

  def save_transfer_between_accounts
    @user = current_user
    @transaction = Transaction.new(user: @user)
    authorize @transaction
    password = transaction_params[:password]
    amount = transaction_params[:amount].to_f
    if @destination_account = User.find_by(cpf: destination_account_params[:cpf])
      if current_user.valid_password?(password)
        bank_fee = calc_bank_fee(amount)
        new_balance = @user.balance - amount - bank_fee
        if new_balance >= 0
          if @destination_account.account_number == destination_account_params[:account_number]
            @transaction = Transaction.new(transaction_type: 'Transferência entre Contas', amount:, user: @user,
                                           old_balance: @user.balance, new_balance:, destination_account_id: @destination_account.id, bank_fee:,
                                           destination_account_old_balance: @destination_account.balance, destination_account_new_balance: @destination_account.balance + amount)
            @user.balance = new_balance
            @destination_account.balance += amount
            if @transaction.save && @user.save && @destination_account.save
              redirect_to root_path, notice: 'Transferência realizado com sucesso'
            else
              redirect_to transfer_between_accounts_path(current_user), notice: "Falha ao salvar"
            end
          else
            redirect_to transfer_between_accounts_path(current_user),
                        notice: "Número da conta não corresponde com o numero do CPF"
          end
        else
          redirect_to transfer_between_accounts_path(current_user), notice: "Saldo insuficiente"
        end
      else
        redirect_to transfer_between_accounts_path(current_user), notice: "Senha incorreta"
      end
    else
      redirect_to transfer_between_accounts_path(current_user), notice: "CPF inválido"
    end
  end

  private

  def calc_bank_fee(amount)
    if DateTime.now.wday.zero? || DateTime.now.wday == 6 || DateTime.now.hour < 9 || DateTime.now.hour >= 18
      bank_fee = 7
    else
      bank_fee = 5
    end
    bank_fee += 10 if amount > 1000
    bank_fee
  end

  def transaction_params
    params.require(:transaction).permit(:amount, :password, :user)
  end

  def destination_account_params
    params[:transaction][:user].permit(:account_number, :cpf)
  end
end

class TransactionsController < ApplicationController
  def deposit
    @user = current_user
    @transaction = Transaction.new
  end

  def save_deposit
    @user = current_user
    password = transaction_params[:password]
    amount = transaction_params[:amount].to_f
    new_balance = @user.balance + amount
    if current_user.valid_password?(password)
      @transaction = Transaction.new(transaction_type: 'Depósito', amount:, user: @user,
                                     old_balance: @user.balance, new_balance:)
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
  end

  def save_withdraw
    @user = current_user
    password = transaction_params[:password]
    amount = transaction_params[:amount].to_f
    new_balance = @user.balance - amount

    if current_user.valid_password?(password)
      @transaction = Transaction.new(transaction_type: 'Saque', amount:, user: @user,
                                     old_balance: @user.balance, new_balance:)
      @user.balance = new_balance
      if @transaction.save && @user.save
        redirect_to root_path, notice: 'Saque realizado com sucesso'
      else
        redirect_to withdraw_path(current_user), notice: "Falha ao salvar"
      end
    else
      redirect_to withdraw_path(current_user), notice: "Senha incorreta"
    end
  end

  def transfer_between_accounts
    @user = current_user
    @transaction = Transaction.new
    @destination_account = User.new
  end

  def save_transfer_between_accounts
    @user = current_user
    password = transaction_params[:password]
    amount = transaction_params[:amount].to_f
    @destination_account = User.find_by(cpf: destination_account_params[:cpf])
    new_balance = @user.balance - amount
    if current_user.valid_password?(password)
      if @destination_account.account_number == destination_account_params[:account_number].to_i
        @transaction = Transaction.new(transaction_type: 'Transferência entre Contas', amount:, user: @user,
                                       old_balance: @user.balance, new_balance:, destination_account_id: @destination_account.id)
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
      redirect_to transfer_between_accounts_path(current_user), notice: "Senha incorreta"
    end
  end

  private

  def transaction_params
    params.require(:transaction).permit(:amount, :password, :user)
  end

  def destination_account_params
    params[:transaction][:user].permit(:account_number, :cpf)
  end
end

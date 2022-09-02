class UsersController < ApplicationController
  def show
    @user = current_user
  end

  def confirmation_destroy
    @user = current_user
  end

  def destroy
    @user = current_user
    password = user_password
    if current_user.valid_password?(password[:password])
      @user.destroy
      redirect_to root_path, notice: 'Sua conta foi encerrada com sucesso'
    else

      redirect_to user_confirmation_destroy_path(current_user), notice: "Senha incorreta"
    end
  end

  def user_password
    params.require(:user).permit(:password)
  end
end

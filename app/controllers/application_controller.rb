class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up,
                                      keys: %i[email full_name address phone_number cpf])
    devise_parameter_sanitizer.permit(:account_update,
                                      keys: %i[email full_name address phone_number cpf])
  end
end

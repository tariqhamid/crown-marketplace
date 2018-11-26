class AuthController < ApplicationController
  skip_before_action :require_sign_in

  def callback
    session[:userinfo] = request.env.dig('omniauth.auth', 'info', 'email')
    redirect_to :homepage
  end

  def sign_out
    session.delete :userinfo
    redirect_to Cognito.logout_path(gateway_url)
  end
end

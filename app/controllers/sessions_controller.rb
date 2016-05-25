class SessionsController < ApplicationController
  require 'jwt'
  before_action :authenticate_session, only: [:logout]

  def login
    unless params.dig(:session, :email) && params.dig(:session, :password)
      head :unauthorized and return
    end
    user = User.find_by(email: params[:session][:email])
    if user && user.authenticate(params[:session][:password])
      payload = {sub: user.id, exp: (Time.now + 1.day).to_i, }
      token = JWT.encode payload, Rails.application.secrets.secret_key_base
      user.update(jwt: token)
      render json: {token: token}
    else
      head :unauthorized
    end
  end

  def logout
    current_user.update(jwt: nil)
    head :ok
  end
end

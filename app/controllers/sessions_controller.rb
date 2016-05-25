class SessionsController < ApplicationController
  require 'jwt'
  before_action :authenticate, only: [:logout]

  def login
    unless params.dig(:session, :email) && params.dig(:session, :password)
      head :bad_request and return
    end
    user = User.find_by(email: params[:session][:email])
    if user && user.authenticate(params[:session][:password])
      payload = {user_id: user.id, exp: (Time.now + 1.day).to_i}
      token = JWT.encode payload, Rails.application.secrets.hmac_secret
      user.update(jwt: token)
      render json: {token: token}
    else
      head :bad_request
    end
  end

  def logout
    current_user.update(jwt: nil)
    head :ok
  end
end

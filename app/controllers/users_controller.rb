class UsersController < ApplicationController
  wrap_parameters :user, include: [:name, :email, :password, :password_confirmation]

  before_action :authenticate_session, only: [:update, :destroy]

  def create
    unless params.dig(:user, :name) && params.dig(:user, :email) && params.dig(:user, :password) && params.dig(:user, :password_confirmation)
      head :bad_request and return
    end
    user = User.new(user_params)
    if user.save
      head :ok and return
    else
      head :bad_request
    end
  end

  def update
    unless params[:id] == current_user.id
      head :not_authorized and return
    end

    if current_user.update(user_params)
      head :ok
    else
      head :bad_request
    end
  end

  def destroy
    unless params[:id] == current_user.id
      head :not_authorized and return
    end

    current_user.destroy
    head :ok
  end

  private
  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
end

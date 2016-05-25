class UsersController < ApplicationController
  wrap_parameters :user, include: [:name, :email, :password, :password_confirmation]

  before_action :authenticate_session, only: [:update, :destroy]

  def create
    unless params.dig(:user, :name) && params.dig(:user, :email) && params.dig(:user, :password) && params.dig(:user, :password_confirmation)
      head :bad_request and return
    end
    user = User.new(user_params)
    if user.save
      render json: user, status: :created
    else
      head :bad_request
    end
  end

  def update
    unless params[:id].to_i == current_user.id
      head :unauthorized and return
    end

    if current_user.update(user_params)
      render json: current_user, status: :ok
    else
      head :bad_request
    end
  end

  def destroy
    unless params[:id].to_i == current_user.id
      head :unauthorized and return
    end

    current_user.destroy
    head :ok
  end

  private
  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
end

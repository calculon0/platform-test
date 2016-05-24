class UsersController < ApplicationController
  wrap_parameters :user, include: [:name, :email, :password, :password_confirmation]

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
  end

  def destroy
  end

  private
  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
end

require 'test_helper'

class SessionsControllerTest < ActionController::TestCase
  def setup
    request.env['HTTP_CONTENT_TYPE'] = 'application/json'
    request.env['HTTP_ACCEPT'] = 'application/json'
    @user = User.create(name: 'Bob', email: 'test@test.com', password: 'password', password_confirmation: 'password')
  end

  test "login with incorrect email" do
    post :login, {session: {email: 'test2@test.com', password: 'password'}}
    assert_response :unauthorized
  end

  test "login with incorrect password" do
    post :login, {session: {email: 'test@test.com', password: 'password2'}}
    assert_response :unauthorized
  end

  test "login with correct credentials" do
    post :login, {session: {email: 'test@test.com', password: 'password'}}
    assert_response :ok
  end

  test "logout without authentication" do
    get :logout
    assert_response :unauthorized
  end

  test "logout successfully" do
    token = Knock::AuthToken.new(payload: { sub: @user.id }).token
    User.find(@user.id).update(jwt: token)
    request.env['HTTP_AUTHORIZATION'] = "Bearer #{token}"
    get :logout
    assert_response :ok
    get :logout
    assert_response :unauthorized
  end
end
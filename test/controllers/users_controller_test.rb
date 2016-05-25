class UsersControllerTest < ActionController::TestCase
  def authenticate
    #token = Knock::AuthToken.new(payload: { sub: users(:one).id }).token
    #request.env['HTTP_AUTHORIZATION'] = "Bearer #{token}"
  end

  def setup
    request.env['HTTP_CONTENT_TYPE'] = 'application/json'
    request.env['HTTP_ACCEPT'] = 'application/json'
  end

  test "create user without name" do
    post :create, {user: {email: 'test@test.com', password: 'password', password_confirmation: 'password_confirmation'}}
    assert_response :bad_request
  end

  test "create user without email" do
    post :create, {user: {name: 'Bob', password: 'password', password_confirmation: 'password_confirmation'}}
    assert_response :bad_request
  end

  test "create user without password" do
    post :create, {user: {name: 'Bob', email: 'test@test.com'}}
    assert_response :bad_request
  end

  test "create user with non-matching password and password_confirmation" do
    post :create, {user: {name: 'Bob', email: 'test@test.com', password: 'password', password_confirmation: 'password2'}}
    assert_response :bad_request
  end

  test "create user with correct fields" do
    post :create, {user: {name: 'Bob', email: 'test@test.com', password: 'password', password_confirmation: 'password'}}
    assert_response :ok
  end

  test "update user without authentication" do
    response = post :create, {user: {name: 'Bob', email: 'test@test.com', password: 'password', password_confirmation: 'password'}}
    put :update, {id: JSON(response.body)['id'], user: {name: 'Bob2', email: 'test2@test2.com', password: 'password2', password_confirmation: 'password2'}}
    assert_response :unauthorized
  end

  test "update a different user" do
    response = post :create, {user: {name: 'Bob', email: 'test@test.com', password: 'password', password_confirmation: 'password'}}
    token = Knock::AuthToken.new(payload: { sub: JSON(response.body)['id'] }).token
    request.env['HTTP_AUTHORIZATION'] = "Bearer #{token}"
    put :update, {id: JSON(response.body)['id']-1, user: {name: 'Bob2', email: 'test2@test2.com', password: 'password2', password_confirmation: 'password2'}}
    assert_response :unauthorized
  end
end
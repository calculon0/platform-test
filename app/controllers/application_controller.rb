class ApplicationController < ActionController::Base
  include Knock::Authenticable

  before_action :ensure_json_request  

  def ensure_json_request  
    return if request.format == :json
    head :not_acceptable
  end

  private
  def authenticate_session
    authenticate
    if current_user.jwt != bearer_token
      head :unauthorized and return
    end
  end

  def bearer_token
    pattern = /^Bearer /
    header  = request.env["HTTP_AUTHORIZATION"]
    header.gsub(pattern, '') if header && header =~ pattern
  end
end

class ApplicationController < ActionController::Base
  before_action :ensure_json_request  

  def ensure_json_request  
    return if request.format == :json
    head :not_acceptable
  end  
end

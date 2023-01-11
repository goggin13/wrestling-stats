class ApplicationController < ActionController::Base
  before_action :authenticate_admin!
  skip_before_action :authenticate_admin!, if: :devise_controller?
  skip_before_action :authenticate_admin!, only: [:access_denied]

  def authenticate_admin!
    authenticate_user!
    unless current_user.email == "goggin13@gmail.com"
      flash["alert"] = "Please authenticate as an admin."
      redirect_to access_denied_path
    end
  end

  def access_denied
  end
end

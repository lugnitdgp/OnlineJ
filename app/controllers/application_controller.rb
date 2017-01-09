class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  def after_sign_in_path_for(_user)
    force_update_url
  end

  def check
    if user_signed_in?
      redirect_to force_update_url if current_user.username.blank?
    end
  end
end

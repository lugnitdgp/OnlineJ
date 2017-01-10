class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  def after_sign_in_path_for(_user)
    force_update_url
  end

  def check
    if user_signed_in? 
      if (current_user.username.blank? || current_user.college.blank?)
        redirect_to force_update_url
      end
    end
  end
end

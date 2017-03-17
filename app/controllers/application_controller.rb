class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  def after_sign_in_path_for(_user)
    force_update_url
  end

  def check
    if user_signed_in?
      if current_user.username.blank? || current_user.college.blank? || current_user.name.blank?
        redirect_to force_update_url
      end
    end
  end

  rescue_from CanCan::AccessDenied do |_exception|
    respond_to do |format|
      format.json { render nothing: true, status: :forbidden }
      format.xml { render xml: '...', status: :forbidden }
      format.html { render file: 'public/500.html', status: :not_found, layout: false }
    end
  end
end

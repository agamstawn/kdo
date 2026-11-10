module Authentication
  extend ActiveSupport::Concern

  included do
    before_action :require_authentication
    helper_method :authenticated?, :current_user
  end

  class_methods do
    def allow_unauthenticated_access(**options)
      skip_before_action :require_authentication, **options
    end
  end

  private

  def current_user
    return Current.user if Current.user
    return if session[:user_id].blank?

    Current.user = User.find_by(id: session[:user_id])
  end

  def authenticated?
    current_user.present?
  end

  def require_authentication
    return if authenticated?

    redirect_to new_session_path, alert: "Silakan masuk untuk mengakses aplikasi."
  end

  def start_session_for(user)
    reset_session
    session[:user_id] = user.id
    Current.user = user
  end

  def end_session
    reset_session
    Current.user = nil
  end
end

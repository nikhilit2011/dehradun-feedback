class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?

  # --- Devise redirects ---
  def after_sign_in_path_for(resource)
    # Default: all users go to the dashboard
    # You can specialize by role if needed:
    # return some_path if resource.school_user?
    admin_dashboard_feedbacks_path
  end

  def after_sign_out_path_for(_resource_or_scope)
    # Send back to the feedback form (public landing)
    root_path
  end

  protected

  # Strong params for Devise (expand if you let admins set role/school from forms)
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [])
    devise_parameter_sanitizer.permit(:account_update, keys: [])
  end

  # --- Role helpers ---
  # Usage: require_roles!(:rto_user, :school_user)   # admin always allowed
  def require_roles!(*roles)
    unless user_signed_in? &&
           (current_user.admin? || roles.any? { |r| current_user.public_send("#{r}?") })
      redirect_to new_user_session_path, alert: "You are not authorized to view that page."
    end
  end

  # For use in views to conditionally show links/buttons
  def can_view_admin_pages?
    user_signed_in? &&
      (current_user.admin? || current_user.rto_user? || current_user.school_user?)
  end
  helper_method :can_view_admin_pages?
end

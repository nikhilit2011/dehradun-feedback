class FeedbacksController < ApplicationController
  # --- Auth/roles (safe if Devise not installed yet) ---
  if defined?(Devise)
    before_action :authenticate_user!, except: [:new, :create]
    before_action :authorize_admin_pages!, only: [:admin_dashboard, :index]
  end

  before_action :load_collections, only: [:new, :create]

  # Public landing (you can keep this or redirect to dashboard)
  def index
    @feedbacks = Feedback
                    .includes(school: :district)
                    .order(created_at: :desc)
                    .page(params[:page])      # ✅ Kaminari
                    .per(20)                  # adjust page size if you like
  end

  # ----- Public form -----
  def new
    @feedback = Feedback.new
  end

  def create
    @feedback = Feedback.new(feedback_params)
    if @feedback.save
      redirect_to feedbacks_path, notice: "Thank you! Your feedback was submitted."
    else
      flash.now[:alert] = "Please fix the errors below."
      render :new, status: :unprocessable_entity
    end
  end

  # ----- Admin Dashboard -----
  def admin_dashboard
    @districts = District.order(:name)
    @schools   = School.order(:name)

    # Eager load to avoid N+1
    scope = Feedback.includes(school: :district).order(created_at: :desc)

    # If you later enable school-level users, auto-scope here (safe if Devise missing)
    if defined?(Devise) && user_signed_in? && current_user.respond_to?(:school_user?) && current_user.school_user? && current_user.school_id.present?
      scope = scope.where(school_id: current_user.school_id)
    else
      # Filters (district via schools table; no district_id on feedbacks)
      if params[:district_id].present?
        scope = scope.joins(school: :district).where(schools: { district_id: params[:district_id] })
      end
      if params[:school_id].present?
        scope = scope.where(school_id: params[:school_id])
      end
    end

    if params[:from_date].present?
      scope = scope.where("feedbacks.created_at >= ?", params[:from_date].to_date.beginning_of_day)
    end
    if params[:to_date].present?
      scope = scope.where("feedbacks.created_at <= ?", params[:to_date].to_date.end_of_day)
    end

    # Pagination: Kaminari if available, else simple fallback
    per_page = (params[:per].presence || 20).to_i.clamp(1, 200)
    if defined?(Kaminari)
      @feedbacks = scope.page(params[:page]).per(per_page)
    else
      page = (params[:page].presence || 1).to_i
      total = scope.count
      @total_pages = (total.to_f / per_page).ceil
      @current_page = [[page, 1].max, [@total_pages, 1].max].min
      @feedbacks = scope.offset((@current_page - 1) * per_page).limit(per_page)
    end
  end

  private

  # Only runs if Devise is present; otherwise treated as a no-op
  def authorize_admin_pages!
    # Allow admin/rto/school users; block logged-out visitors
    return if !defined?(Devise) # if Devise not installed, don’t block

    # If Devise is installed but user not signed in -> login
    unless user_signed_in?
      redirect_to new_user_session_path, alert: "Please sign in to continue."
      return
    end

    # If you have roles set up on User (enum), allow these:
    if current_user.respond_to?(:admin?) && (current_user.admin? || current_user.rto_user? || current_user.school_user?)
      return
    end

    # Default deny
    redirect_to root_path, alert: "You are not authorized to view that page."
  end

  def load_collections
    @districts = District.order(:name)
    @schools   = School.order(:name)
  end

  def feedback_params
    params.require(:feedback).permit(
      :school_id, :parent_name, :contact, :vehicle_number,
      :vehicle_category, :praise_note, :overall_rating,
      :comments,
      issues: []
    )
  end
end

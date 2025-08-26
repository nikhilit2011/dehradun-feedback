class Admin::SchoolsController < ApplicationController
  before_action :authenticate_user!
  before_action -> { require_roles!(:rto_user) }
  before_action :set_school, only: [:edit, :update, :destroy]
  before_action :load_districts, only: [:new, :create, :edit, :update]

  def index
    @schools = School.includes(:district).order("districts.name ASC, schools.name ASC")
  end

  def new
    @school = School.new
  end

  def create
    @school = School.new(school_params)
    if @school.save
      redirect_to admin_schools_path, notice: "School created successfully."
    else
      flash.now[:alert] = "Please fix the errors below."
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @school.update(school_params)
      redirect_to admin_schools_path, notice: "School updated."
    else
      flash.now[:alert] = "Please fix the errors below."
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if Feedback.exists?(school_id: @school.id)
      redirect_to admin_schools_path, alert: "Cannot delete: feedback exists for this school."
    else
      @school.destroy
      redirect_to admin_schools_path, notice: "School deleted."
    end
  end

  private

  def set_school
    @school = School.find(params[:id])
  end

  def load_districts
    @districts = District.order(:name)
  end

  def school_params
    params.require(:school).permit(:name, :district_id)
  end
end

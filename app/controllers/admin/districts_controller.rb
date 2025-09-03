class Admin::DistrictsController < ApplicationController
  before_action :authenticate_user!
  before_action -> { require_roles!(:rto_user) }   # admins pass via helper
  before_action :set_district, only: [:edit, :update, :destroy]

  def index
    @districts = District.order(:name)
  end

  def new
    @district = District.new
  end

  def create
    @district = District.new(district_params)
    if @district.save
      redirect_to admin_districts_path, notice: "District created successfully."
    else
      flash.now[:alert] = "Please fix the errors below."
      render :new, status: :unprocessable_entity
    end
  end
  
  def schools
    district = District.find(params[:id])
    schools = district.schools.select(:id, :name)

    # Build response with "Other" at the end
    school_list = schools.map { |s| { id: s.id, name: s.name } }
    school_list << { id: "other", name: "Other" }

    render json: school_list
  end

  def edit; end

  def update
    if @district.update(district_params)
      redirect_to admin_districts_path, notice: "District updated."
    else
      flash.now[:alert] = "Please fix the errors below."
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @district.schools.exists?
      redirect_to admin_districts_path, alert: "Cannot delete: remove or reassign its schools first."
    else
      @district.destroy
      redirect_to admin_districts_path, notice: "District deleted."
    end
  end

  private

  def set_district
    @district = District.find(params[:id])
  end

  def district_params
    params.require(:district).permit(:name)
  end
end

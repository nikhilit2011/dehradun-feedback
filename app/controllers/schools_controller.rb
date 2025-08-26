# app/controllers/schools_controller.rb
class SchoolsController < ApplicationController
  def index
    @schools = School.where(district_id: params[:district_id])
    render json: @schools.map { |s| { id: s.id, name: s.name } }
  end
end

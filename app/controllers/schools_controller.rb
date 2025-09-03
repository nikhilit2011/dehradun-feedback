# app/controllers/schools_controller.rb
class SchoolsController < ApplicationController
  def index
    schools = School.where(district_id: params[:district_id]).select(:id, :name)

    # Convert to array of hashes
    school_list = schools.map { |s| { id: s.id, name: s.name } }

    # Always add "Other" option at the end
    school_list << { id: "other", name: "Other" }

    render json: school_list
  end
end

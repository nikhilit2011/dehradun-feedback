module Admin
  class UsersController < BaseController
    before_action :set_user, only: [:edit, :update, :destroy]

    def index
      @users = User.includes(:school).order(created_at: :desc)
    end

    def new
      @user = User.new
      load_schools
    end

    def create
      @user = User.new(user_params)
      if @user.save
        redirect_to admin_users_path, notice: "User created."
      else
        load_schools
        flash.now[:alert] = "Please fix the errors below."
        render :new, status: :unprocessable_entity
      end
    end

    def edit
      load_schools
    end

    def update
      attrs = user_params
      # allow blank password on edit
      if attrs[:password].blank?
        attrs.delete(:password)
        attrs.delete(:password_confirmation)
      end

      if @user.update(attrs)
        redirect_to admin_users_path, notice: "User updated."
      else
        load_schools
        flash.now[:alert] = "Please fix the errors below."
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      if @user == current_user
        redirect_to admin_users_path, alert: "You cannot delete yourself."
      else
        @user.destroy
        redirect_to admin_users_path, notice: "User deleted."
      end
    end

    private

    def set_user
      @user = User.find(params[:id])
    end

    def load_schools
      @schools = School.order(:name)
    end

    def user_params
      params.require(:user).permit(:email, :password, :password_confirmation, :role, :school_id)
    end
  end
end

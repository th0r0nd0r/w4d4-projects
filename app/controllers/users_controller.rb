class UsersController < ApplicationController
  before_action :redirect_if_logged_in
  skip_before_action :redirect_if_logged_in, except: [:new]

  def create
    @user = User.new(user_params)

    if @user.save
      login!(@user)
      redirect_to cats_url
    else
      render json: @user.errors.full_messages
    end
  end

  def new
    @user = User.new
    render :new
  end

  def show
    render :show
  end


  private

  def redirect_if_logged_in
    if current_user
      redirect_to cats_url
    end
  end

  def user_params
    params.require(:user).permit(:user_name, :password)
  end
end

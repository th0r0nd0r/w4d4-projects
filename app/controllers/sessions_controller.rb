class SessionsController < ApplicationController
  before_action :redirect_if_logged_in
  skip_before_action :redirect_if_logged_in, except: [:new]

  def new
    render :new
  end

  def create
    user = User.find_by_credentials(user_params[:user_name], user_params[:password])
    if user
      login!(user)
      redirect_to cats_url
    else
      render json: 'Credentials were wrong got dangit'
    end
  end

  def destroy
    user = current_user
    if user
      logout!(user)
    end
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

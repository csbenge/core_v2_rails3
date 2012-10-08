class SessionsController < ApplicationController
  
  skip_before_filter :authorize
  skip_before_filter :session_expiry
  before_filter :update_activity_time
  
  def new
  end

  def create
    if user = User.authenicate(params[:user_id], params[:password])
      @user_id = params[:user_id]
      session[:user_id] = @user_id
      @role = Role.find(user.role_id)
      session[:user_role] = @role.name
      redirect_to home_url, :alert => t(:session_welcome) + @user_id
    else
      redirect_to login_url, :alert => t(:session_bad_uid)
    end
  end

  def destroy
    session[:user_id] = nil
    session[:user_role] = nil
    redirect_to login_url, :alert => t(:session_logged_out)
  end
  
end

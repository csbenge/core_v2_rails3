class ApplicationController < ActionController::Base
  
  helper_method :sort_column, :sort_direction
  before_filter :authorize
  before_filter :session_expiry
  before_filter :update_activity_time
  
  # Initialize logg3r and level
  Logg3r = Log4r::Logger.new("depot")
  Logg3r.add Log4r::FileOutputter.new( "datical", {:filename=>"log/datical.log"} )
  Logg3r.level = Log4r::DEBUG
 
  protect_from_forgery
  
  protected
  
  SESSION_TIMEOUT = 15            # in minutes
  
  def authorize
    unless User.find_by_name(session[:user_id])
      redirect_to login_url, :alert => t(:session_login) 
    end
  end
  
  include SessionsHelper
    
  def session_expiry
    get_session_time_left
    unless @session_time_left > 0
      session[:user_id] = nil
      session[:user_role] = nil
      redirect_to login_url, :alert => t(:session_timeout) 
    end
  end

  def update_activity_time
    session[:expires_at] = SESSION_TIMEOUT.minutes.from_now
  end

  private

  def get_session_time_left
    expire_time = session[:expires_at] || Time.now
    @session_time_left = (expire_time - Time.now).to_i
  end
  
  def sort_column  
    params[:sort] || "name"  
  end  
    
  def sort_direction  
    params[:direction] || "asc"  
  end  

end

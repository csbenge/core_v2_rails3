class Worker < ActiveRecord::Base
  attr_accessible :wrk_description, :wrk_hashed_password, :wrk_host, :wrk_name, :wrk_port, :wrk_type, :wrk_user, :wrk_auth_token
  
  validates :wrk_description, :wrk_hashed_password, :wrk_host, :wrk_name, :wrk_port, :wrk_type, :wrk_user, :wrk_auth_token, :presence => true
end

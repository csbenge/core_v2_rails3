class Engine < ActiveRecord::Base
  attr_accessible :eng_description, :eng_host, :eng_name, :eng_threads, :eng_type
  
  validates :eng_description, :eng_host, :eng_name, :eng_threads, :eng_type, :presence => true
end

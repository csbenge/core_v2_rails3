# == Schema Information
#
# Table name: depots
#
#  id         :integer         not null, primary key
#  dep_name   :string(255)
#  dep_desc   :string(255)
#  dep_status :integer
#  dep_type   :integer
#  dep_url    :string(255)
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

class Depot < ActiveRecord::Base
  attr_accessible :dep_name, :dep_desc, :dep_type, :dep_url, :dep_status
  
  validates :dep_name, length: { minimum: 4 }, :presence => true
  validates :dep_desc, :dep_type,:dep_status, :presence => true
  
  has_many :packages, :dependent => :destroy

end

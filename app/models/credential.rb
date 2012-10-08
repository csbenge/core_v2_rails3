# == Schema Information
#
# Table name: credentials
#
#  id         :integer         not null, primary key
#  depot_id   :integer
#  user_id    :integer
#  role_id    :integer
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

class Credential < ActiveRecord::Base
  attr_accessible :depot_id, :user_id, :role_id
  
  validates :depot_id, :presence => true
  validates :user_id, :presence => true
  validates :role_id, :presence => true
  
  has_many :depots
end

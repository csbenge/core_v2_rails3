# == Schema Information
#
# Table name: roles
#
#  id          :integer         not null, primary key
#  name        :string(255)
#  description :string(255)
#  read        :integer         default(0)
#  write       :integer         default(0)
#  execute     :integer         default(0)
#  created_at  :datetime        not null
#  updated_at  :datetime        not null
#

class Role < ActiveRecord::Base
  attr_accessible :name, :description, :read, :write, :execute
  
  validates :name, length: { minimum: 4 }, :presence => true, :uniqueness => true
  validates :description, :presence => true  
end

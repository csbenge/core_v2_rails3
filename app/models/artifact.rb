# == Schema Information
#
# Table name: artifacts
#
#  id          :integer         not null, primary key
#  art_name    :string(255)
#  art_desc    :string(255)
#  art_type    :integer(255)
#  art_version :string(255)
#  package_id  :integer
#  created_at  :datetime        not null
#  updated_at  :datetime        not null
#  art_url     :string(255)
#

class Artifact < ActiveRecord::Base
  attr_accessible :art_name, :art_desc, :art_type, :art_version
  attr_accessible :art_url
  
  validates :art_name, :art_desc, :art_type, :art_version, :presence => true
  
  belongs_to :package
end

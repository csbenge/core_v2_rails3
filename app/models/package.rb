# == Schema Information
#
# Table name: packages
#
#  id          :integer         not null, primary key
#  pkg_name    :string(255)
#  pkg_desc    :string(255)
#  pkg_type    :integer(255)
#  pkg_version :string(255)
#  depot_id    :integer
#  created_at  :datetime        not null
#  updated_at  :datetime        not null
#  pkg_status  :integer
#  pkg_url     :string(255)
#

class Package < ActiveRecord::Base
  attr_accessible :pkg_name, :pkg_desc, :pkg_type, :pkg_version, :pkg_status, :pkg_url
  
  validates :pkg_name, :presence => { presence => true, :message => "bad name" }
  validates :pkg_desc, :pkg_type, :pkg_version, :pkg_status, :presence => true
  
  belongs_to :depot
  has_many :artifacts, :dependent => :destroy
end

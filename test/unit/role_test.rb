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

require 'test_helper'

class RoleTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end

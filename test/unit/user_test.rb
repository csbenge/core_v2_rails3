# == Schema Information
#
# Table name: users
#
#  id              :integer         not null, primary key
#  name            :string(255)
#  hashed_password :string(255)
#  salt            :string(255)
#  email           :string(255)
#  role_id         :string(255)
#  created_at      :datetime        not null
#  updated_at      :datetime        not null
#  firstname       :string(255)
#  lastname        :string(255)
#

require 'test_helper'

class UserTest < ActiveSupport::TestCase
  fixtures :users
  test "user attributes must not be empty" do
    #user = User.new
    assert_equal 2, User.count
    assert_equal "testuser", users(:one).name
    assert_equal "testuser@test.com", users(:one).email
    assert_equal "User", users(:one).role
  end
end

module UsersHelper
  
  def get_RoleName(user_role)
    @role = Role.find_by_id(user_role)
    @role.name
  end
  
end


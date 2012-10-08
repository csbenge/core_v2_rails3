module CredentialsHelper
  
  def get_DepotName(depot_id)
    @depot = Depot.find_by_id(depot_id)
    @depot.dep_name
  end
    
  def get_UserName(user_id)
    @user = User.find_by_id(user_id)
    @user.name
  end
   
  def get_RoleName(role_id)
    @role = Role.find_by_id(role_id)
    @role.name
  end
  
  def get_RoleRead(role_id)
    @role = Role.find_by_id(role_id)
    @role.read
  end
  
  def get_RoleWrite(role_id)
    @role = Role.find_by_id(role_id)
    @role.write
  end
  
  def get_RoleExecute(role_id)
    @role = Role.find_by_id(role_id)
    @role.execute
  end
  
end

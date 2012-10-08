module DepotsHelper
  
  STATUS = {'Online' => 1, 'Offline' => 2, 'Service' => 3}
  TYPE   = {'Local' => 1, 'Remote' => 2, 'Proxy' => 3}
    
  def get_DepotStatusText(depot_status)
    status = STATUS.index(depot_status)
    if status == "Online"
      "<span class='label label-success'>#{status}</span>"
    elsif status == "Offline"
      "<span class='label label-important'>#{status}</span>"
    elsif status == "Service"
      "<span class='label label-warning'>#{status}</span>"
    end
  end
  
  def get_DepotTypeText(depot_type)
    type = TYPE.index(depot_type)
    "<span class='label label-default'>#{type}</span>"
  end
  
  def user_HasCredToDepot(depot_id, user_id)
    @user = User.find_by_name(user_id)
    user_id = @user.id
    cred = Credential.find(:all, :conditions => {:depot_id => depot_id, :user_id => user_id})
    if cred == []
      return false
    else
      return true
    end
  end
  
  def user_HasWriteAccess(depot_id, user_id)
    @user = User.find_by_name(user_id)
    user_id = @user.id
    @cred = Credential.find(:all, :conditions => {:depot_id => depot_id, :user_id => user_id})
    role_id = @cred[0][:role_id]
    role = Role.find_by_id(role_id)
    if role.write == 1
      return true
    else
      return false
    end
  end
  
    def user_HasCanCreateDepot(user_id)
    @user = User.find_by_name(user_id)
    role_id = @user.role_id
    role = Role.find_by_id(role_id)
    if role.write == 1
      return true
    else
      return false
    end
  end
  
end

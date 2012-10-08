module RolesHelper
  
  def display_input(name, value)
    if value.to_s == 1.to_s
      content = "<input id='permissions_permissions_#{name}' name='permissions[permissions][]' type='checkbox' value='#{name}' checked='checked' />"   
    else
       content = "<input id='permissions_permissions_#{name}' name='permissions[permissions][]' type='checkbox' value='#{name}' />"   
    end
    
    render(:inline=> content)
  end
  
end
  
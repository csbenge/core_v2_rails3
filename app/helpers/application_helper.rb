module ApplicationHelper

  # Returns the full title on a per-page basis.       # Documentation comment
  def full_title(page_title)                          # Method definition
    base_title = t(:app_name)  # Variable assignment
    if page_title.empty?                              # Boolean test
      base_title                                      # Implicit return
    else
      "#{base_title} | #{page_title}"                 # String interpolation
    end
  end
   
  def sortable(column, title = nil)  
    title ||= column.titleize
    direction = (column == sort_column && sort_direction == "asc") ? "desc" : "asc"  
    link_to title, :sort => column, :direction => direction
  end

  def admin_only(&block)
    role_only("Admin", &block)
  end

  def manager_only(&block)
    role_only("Manager", &block)
  end

  private

  def role_only(rolename, &block)
    if session[:user_id] != nil and session[:user_role] == rolename
      block.call
    end
  end

end
module PackagesHelper
    
  STATUS = {'Online' => 1, 'Offline' => 2, 'Service' => 3, 'Archive' => 4}
  TYPE = {'Major' => 1, 'Minor' => 2, 'Hotfix' => 3}

    
  def get_PackageStatusText(package_status)
    status = STATUS.index(package_status)
    if status == "Online"
      "<span class='label label-success'>#{status}</span>"
    elsif status == "Offline"
      "<span class='label label-important'>#{status}</span>"
    elsif status == "Service"
      "<span class='label label-warning'>#{status}</span>"
     elsif status == "Archive"
      "<span class='label label-default'>#{status}</span>"
    end
  end
  
  
  def get_PackageTypeText(package_type)
    package_type = TYPE.index(package_type)
    "<span class='label label-default'>#{package_type}</span>"
  end  
  
  
end

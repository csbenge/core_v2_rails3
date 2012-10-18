module WorkersHelper
  
  TYPE   = {'Linux_x86_32' => 1, 'Linux_x86_64' => 2, 'Windows' => 3}
  
  def get_WorkerTypeText(worker_type)
    type = TYPE.index(worker_type.to_i)
    "<span class='label label-default'>#{type}</span>"
  end
   
end

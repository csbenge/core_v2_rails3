module SchedulesHelper
  
  STATUS = {'Enabled' => 1, 'Disabled' => 2}
  
  def get_ScheduleStatusText(schedule_status)
    status = STATUS.index(schedule_status.to_i)
    if status == "Enabled"
      "<span class='label label-success'>#{status}</span>"
    elsif status == "Disabled"
      "<span class='label label-important'>#{status}</span>"
    end
  end
  
  def get_UserName(user_id)
    @user = User.find_by_id(user_id)
    @user.name
  end
  
  def get_ScheduleNextRun(schedule)
    'Tomorrow'
  end
  
end

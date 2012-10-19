class Schedule < ActiveRecord::Base
  attr_accessible :sch_action, :sch_cronspec, :sch_name, :sch_status, :sch_user
end

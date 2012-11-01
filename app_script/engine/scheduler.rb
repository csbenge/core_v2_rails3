################################################################################
#                     Copyright @ 2012,2013 CloudDepot, Inc.                   #
#                               All Rights Reserved                            #
################################################################################

#======================================#
# Scheduler
#======================================#

module Scheduler

  class SchedulerWK
    attr_accessor :min, :hour, :dmonth, :month, :dweek, :lastrun, :timeout, :cmd

    def lookup_schedules()
      ActiveRecord::Base.establish_connection(
        :adapter  => 'postgresql',
        :database => 'datical_development',
        :username => 'postgres',
        :password => 'postgres',
        :host     => 'localhost')
       
      schedules = Schedule.find(:all)
      return schedules
    end
    
    def time_to_run(job)
      time = Time.new
      sched = SchedulerWK.new
      sched.min, sched.hour, sched.dmonth, sched.month, sched.dweek = job.sch_cronspec.split(/\s+/)
      sched.cmd = job.sch_action
        
      # Got current time and sched entry - time to run?
      if ( (time.month.to_i == sched.month.to_i) || (sched.month == "*") )
        if ( (time.day.to_i == sched.dmonth.to_i) || (sched.dmonth == "*") )
          if ( (time.wday.to_i == sched.dweek.to_i) || (sched.dweek == "*") )
            if ( (time.hour.to_i == sched.hour.to_i) || (sched.hour == "*") ) 
              if ( (time.min.to_i == sched.min.to_i) || (sched.min == "*") )
                 return true
              else if sched.min =~ /^\*/
                step = sched.min.length > 1 ? sched.min[2..-1].to_i : 1
                if time.min.to_i % step == 0
                  return true
                end
              end
            end
            else
              if sched.hour =~ /^\*/
                step = sched.hour.length > 1 ? sched.hour[2..-1].to_i : 1
                if time.hour.to_i % step == 0
                  return true
                end
            end
          end
        end
      end
      return false
    end
    end
    
    
  end
end




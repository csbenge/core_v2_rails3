################################################################################
#                     Copyright @ 2012,2013 CloudDepot, Inc.                   #
#                               All Rights Reserved                            #
################################################################################

#======================================#
# Scheduler
#======================================#

module Scheduler

  class Schedule
    attr_accessor :min, :hour, :dmonth, :month, :dweek, :timeout, :cmd
    
    def time_to_run(job)
      time = Time.new
      sched = Schedule.new
      # scheduler.time_to_run("15 * * * * 3600 [command] ")
      sched.min, sched.hour, sched.dmonth, sched.month, sched.dweek, sched.timeout, sched.cmd = job.split(" ")
        
      # Got current time and sched entry - time to run?
      if ( (time.month.to_i == sched.month.to_i) || (sched.month == "*") )
        if ( (time.day.to_i == sched.dmonth.to_i) || (sched.dmonth == "*") )
          if ( (time.wday.to_i == sched.dweek.to_i) || (sched.dweek == "*") )
            if ( (time.hour.to_i == sched.hour.to_i) || (sched.hour == "*") )
              if ( (time.min.to_i == sched.min.to_i) || (sched.min == "*") )
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


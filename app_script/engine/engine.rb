#!/usr/bin/ruby
################################################################################
#                     Copyright @ 2012,2013 CloudDepot, Inc.                   #
#                               All Rights Reserved                            #
################################################################################

#======================================#
# Engine
#======================================#

require "rubygems"
require "active_record"
require 'logger'
require 'pg'
require 'socket'
require "yaml"

require './initialization'
include Initialization

require './scheduler'
include Scheduler

class Worker < ActiveRecord::Base
end

class Schedule < ActiveRecord::Base
end

#-----------------------------------#
# lookup_worker
#-----------------------------------#

def lookup_worker(id)
  
  ActiveRecord::Base.establish_connection(
    :adapter  => 'postgresql',
    :database => 'datical_development',
    :username => 'postgres',
    :password => 'postgres',
    :host     => 'localhost')
   
  worker = Worker.find(id)
  return worker
end

#-----------------------------------#
# run_task
#-----------------------------------#

def run_task(task)
  
  # Connect to Worker and authenticate
  this_worker = lookup_worker(1)
  
  begin
    clientSession = TCPSocket.new(this_worker.wrk_host, this_worker.wrk_port )
  rescue
     log_msg = "ENGINE: Cannot connect to WORKER: " + this_worker.wrk_host + " on PORT: " + this_worker.wrk_port.to_s
     $log.info log_msg
  else
    $log.info "ENGINE: Authenticating Connection with WORKER."
    clientSession.puts this_worker.wrk_auth_token
    workerResponse = clientSession.gets
    if workerResponse.include? "CONNECTION ACCEPTED"
      $log.info "ENGINE: " + workerResponse
      $log.info "ENGINE: Sending tasks to WORKER."
      clientSession.puts task
      
      # Wait for messages from the agent
      
      puts "----- BEGIN: OUTPUT -----"
       
      while !(clientSession.closed?) && (workerResponse = clientSession.gets)
        ## lets output our server messages
        puts workerResponse
        
        #if one of the messages contains 'Goodbye' we'll disconnect
        ## we disconnect by 'closing' the session.
        
        if workerResponse.include?("Goodbye")
          puts "----- END: OUTPUT -----"
          $log.info "ENGINE: closing connection"
          clientSession.close
        end
      end
    else # Not authoriized to connect to worker
       $log.info "ENGINE: " + workerResponse
    end
  end
end

#===================================#
# MAIN 
#===================================#

init_Settings()
init_License()
init_Logger("DEBUG")
$log.info "ENGINE: Starting..."
$log.info "ENGINE: License - " + "Term:" + decrypt_it("term", $lic["term"]) + ", " +
                                 "Users:" + decrypt_it("users", $lic["users"]) + ", " +
                                 "Workers:" + decrypt_it("workers", $lic["workers"])

sched = SchedulerWK.new
STATUS = {'Enabled' => 1, 'Disabled' => 2}
 
#loop do

#
### Run thru schedule table and run job if it it time.
#
schedules = sched.lookup_schedules()
  for job in schedules
    status = STATUS.key(job.sch_status.to_i)
    if status == "Disabled"
      next
    end
    if sched.time_to_run(job)
        thisSched = SchedulerWK.new
        thisSched.min, thisSched.hour, thisSched.dmonth, thisSched.month, thisSched.dweek = job.sch_cronspec.split(/ /, 7)
        thisSched.cmd = job.sch_action
        $log.info "ENGINE: Running Scheduled Task: " + thisSched.cmd
        run_task(thisSched.cmd)
    end
  end

# 
### Run thru job table and see if any are ready to run
#

  # sleep $sleep_Interval
  
#end loop do

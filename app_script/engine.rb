#!/usr/bin/ruby
################################################################################
#                     Copyright @ 2012,2013 CloudDepot, Inc.                   #
#                               All Rights Reserved                            #
################################################################################

#======================================#
# Engine
#======================================#

require 'logger'
require 'socket'

require './initialization'
include Initialization

require './scheduler'
include Scheduler

#-----------------------------------#
# run_task
#-----------------------------------#

def run_task(task)
  
  # Connect to Worker and authenticate
  clientSession = TCPSocket.new("localhost", 50000 )
  $log.info "ENGINE: Authenticating Connection with WORKER."
  clientSession.puts $auth_key
  
  $log.info "ENGINE: Sending tasks to WORKER."
  clientSession.puts task
  
  # Wait for messages from the worker
  
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

sched = Schedule.new
sched_jobs = [ "* * 27 * * 3600 ls -l;ls -a;.scp src dst",
               "* * 27 * * 3600 cat /etc/hosts ",
               "* 22 * * * 3600 ls /etc ",
               "* * * 9 * 3600 sleep 5",
               "* * * 9 * 3600 ls",
               "* * * 9 * 3600 cat /etc/hosts",
               "* * * 9 * 3600 sleep 25;ls -a"
             ]
  
threads      = []
thread_count = 0

#loop do

# Run thru schedule table and run job if it it time.
  for job in sched_jobs
    if sched.time_to_run(job)
      thread_count += 1
      puts "***Thread Count: " + thread_count.to_s
      threads << Thread.new(job) { |thisJob|
        thisSched = Schedule.new
        thisSched.min, thisSched.hour, thisSched.dmonth, thisSched.month, thisSched.dweek, thisSched.timeout, thisSched.cmd = thisJob.split(/ /, 7)
        #sched.min, sched.hour, sched.dmonth, sched.month, sched.dweek, sched.timeout, sched.cmd = thisJob.split(/ /, 7)
        $log.info "ENGINE: Running Scheduled Task: " + thisSched.cmd
        run_task(thisSched.cmd)
        thread_count -= 1
        puts "***Thread Count: " + thread_count.to_s
      }
    end
  end
  
  threads.each { |aThread|  aThread.join }
  
  # Run thru job table and see if any are ready to run
  
  # sleep $sleep_Interval
#end loop do

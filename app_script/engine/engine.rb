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
  #worker = Worker.new
  #worker.wrk_host = "localhost"
  #worker.wrk_port = "50000"
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
    clientSession.puts $auth_key
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

sched = Schedule.new
sched_jobs = [ "* * 27 * * 3600 ls -l;ls -a;.scp src dst",
               "* * 27 * * 3600 cat /etc/hosts ",
               "* */6 * * * 3600 ls /etc ",
               "*/15 * * * * 3600 sleep 5",
               "* * * * * 3600 ls",
               "* * * 9 * 3600 cat /etc/hosts",
               "* * * 9 * 3600 sleep 25;ls -a",
               "* * * * * 3600 sleep 5;ls -a",
               "* * * * * 3600 sleep 10;ls -a",
               "* * * * * 3600 sleep 15;ls -a",
               "* * * * * 3600 sleep 20;ls -a",
               "* * * * * 3600 sleep 25;ls -a;env"
             ]
  
threads      = []
thread_count = 0

#loop do

# Run thru schedule table and run job if it it time.
  for job in sched_jobs
    if sched.time_to_run(job)
      thread_count += 1
      #while thread_count > 10
      #  puts "***Waiting for thread..."
      #  sleep(5)
      #end
      #puts "***RUN: Thread: " + thread_count.to_s + ", Job: " + job
      #threads << Thread.new(job) { |thisJob|
        thisSched = Schedule.new
        thisSched.min, thisSched.hour, thisSched.dmonth, thisSched.month, thisSched.dweek, thisSched.timeout, thisSched.cmd = job.split(/ /, 7)
        $log.info "ENGINE: Running Scheduled Task: " + thisSched.cmd
        run_task(thisSched.cmd)
      #  thread_count -= 1
      #  puts "***Thread Count: " + thread_count.to_s
      #}
    end
  end
  
  #threads.each { |aThread|
  #  aThread.join
  #}
  
# Run thru job table and see if any are ready to run
  
  # sleep $sleep_Interval
#end loop do

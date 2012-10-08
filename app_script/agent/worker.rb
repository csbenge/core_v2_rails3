#!/usr/bin/ruby
################################################################################
#                     Copyright @ 2012,2013 CloudDepot, Inc.                   #
#                               All Rights Reserved                            #
################################################################################

#======================================#
# Worker
#======================================#

require 'logger'
require 'popen4'
require 'socket'
require 'yaml'

#-----------------------------------#
# init_Settings
#-----------------------------------#

def init_Settings
  config      = YAML.load_file("worker_settings.yml")
	$auth_key   = config["worker"]["auth_key"]
	$port       = config["worker"]["port"]
end

#-----------------------------------#
# init_Logger
#-----------------------------------#

def init_Logger(level)
  $log = Logger.new(STDOUT)
  $log.level = Logger::DEBUG
  $log.formatter = proc do |severity, datetime, progname, msg|
    "#{datetime} - #{severity} - #{msg}\n"
  end
end

#-----------------------------------#
# process_dotCommands
#-----------------------------------#

def process_dotCommands(cmd)
  # grab first word
  dcmd = cmd.split[0]
  case dcmd
    when ".hostname" 
      return Socket.gethostname
    when ".os" 
      return RUBY_PLATFORM
    when ".ping"
      return 'I am alive!'
    when ".scp"
      return 'Secure file copy'
    when ".setenv"
      puts 'Set environment variable'
    else
      puts "Not a valid dot command."
  end
end

#===================================#
# MAIN 
#===================================#

init_Settings()
init_Logger("DEBUG")

$log.info "WORKER: Starting..."
server = TCPServer.new($port)
$log.info "WORKER: Waiting for task..."

#-----------------------------------#
# Loop 4ever
#-----------------------------------#

thread_count = 0

loop do
  Thread.start(server.accept)  do |session| # Wait for a connection
    
  authenticated_connection = false
  thread_count += 1
  puts "***Thread Count: " + thread_count.to_s
  
    $log.info "WORKER: Connection to ENGINE - #{session.peeraddr[2]}"
    
    if authenticated_connection == false
        key = session.gets
    end
    if key.chomp == $auth_key
      authenticated_connection = true
      $log.info "WORKER:   Authenticated ENGINE - #{session.peeraddr[2]}"
      session.puts "from WORKER: CONNECTION ACCEPTED."
    else
      $log.warn "WORKER: UNAUTHORIZED CONNECTION ATTEMPT."
      session.puts "from WORKER: UNAUTHORIZED CONNECTION ATTEMPT, Goodbye."
      next
    end
    
    #-- BEGIN: Process Task(s)
    
    tasks = session.gets
    $log.info "WORKER:   Task(s) - #{tasks}".chomp
    
    tasks.split(';').each do |task|
      
      if task[0] == "."
        result = process_dotCommands("#{task}")
        session.puts result 
        next
      end
      session.puts "TASK: " + "#{task}"
      status = POpen4::popen4("#{task}") do |stdout, stderr, stdin|  
        stdout.each do |line|  
          session.puts line  
        end
        stderr.each do |line|  
          session.puts line  
        end 
      end  
      if status == nil
        session.puts "from WORKER: Invalid task(s): #{tasks}"
      end
    end
    
    #-- END: Process Tasks
    
    # Close connection to Engine
    session.puts "from WORKER: Goodbye."
    authenticated_connection = false
    
    $log.info "WORKER: Waiting for task..."
  end
  
end

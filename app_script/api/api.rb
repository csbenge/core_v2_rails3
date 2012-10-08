################################################################################
#                     Copyright @ 2012,2013 CloudDepot, Inc.                   #
#                               All Rights Reserved                            #
################################################################################

#======================================#
# API.rb - Cloud Depot API/CLI
#======================================#

require "rubygems"
require "active_record"
require 'logger'
require 'pg'
require 'socket'
require "yaml"

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

#----------------------------#
# init_API()
#----------------------------#

class Worker < ActiveRecord::Base
end

def init_API()
	
	 ActiveRecord::Base.establish_connection(
    :adapter  => 'postgresql',
    :database => 'datical_development',
    :username => 'postgres',
    :password => 'postgres',
    :host     => 'localhost')
	 
end

#-----------------------------------#
# lookup_worker
#-----------------------------------#

def lookup_worker(id)
  worker = Worker.find(id)
  return worker
end

#----------------------------#
# process_CMD()
#----------------------------#

def process_CMD(argv)
	case argv[0]
		when "login"
			process_Login_CMD(argv)
		when "depot"
			process_Depot_CMD(argv)
		when "package"
			process_Package_CMD(argv)
		when "artifact"
			process_Artifact_CMD(argv)
		when "instance"
			process_Instance_CMD(argv)
		when "credential"
			process_Credential_CMD(argv)
		when "test"
			return process_Test_CMD(argv)
		else # Display Help
			STDOUT.puts "\nUsage: api COMMAND OPTIONS..."
			STDOUT.puts ""
			STDOUT.puts "Commands:"
			STDOUT.puts "  login username password"
			STDOUT.puts "  depot [create|destroy|modify] [options]"
			STDOUT.puts "  package [create|destroy|modify] [options]"
			STDOUT.puts "  artifact [create|destroy|modify] [options]"
			STDOUT.puts "  instance [create|destroy|modify] [options]"
			STDOUT.puts "  credential [create|destroy|modify] [options]"
	end
end

#----------------------------#
# process_Login_CMD()
#----------------------------#

def process_Login_CMD(argv)
	if argv[2]
		STDOUT.puts "login user=" + argv[1] + ", password=" + argv[2]
	else # Display Help
		STDOUT.puts "\nUsage: cd_api login USERNAME PASSWORD"
	end
end

#----------------------------#
# process_Depot_CMD()
#----------------------------#

def process_Depot_CMD(argv)
	case argv[0]
	when "list"
		process_Depot_List_CMD(argv)
	else # Display Help
		STDOUT.puts "\nUsage: cd_api depot COMMAND OPTIONS..."
		STDOUT.puts ""
		STDOUT.puts "Commands:"
		STDOUT.puts "  depot create [options]"
		STDOUT.puts "  depot destroy [options]"
		STDOUT.puts "  depot modify [options]"
		STDOUT.puts "  depot list [options]"
	end
end

def process_Depot_List_CMD(argv)
	if argv[2]
		STDOUT.puts "\nPackages in Depot: " + argv[2]
	else
		STDOUT.puts "depot list all"
		# packages = findAll()
		STDOUT.puts "<<END>>"
	end
end

#----------------------------#
# process_Package_CMD()
#----------------------------#

def process_Package_CMD(argv)
  STDOUT.puts "package create"
end

#----------------------------#
# process_Artifact_CMD()
#----------------------------#

def process_Artifact_CMD(argv)
  STDOUT.puts "package create"
end

#----------------------------#
# process_Instance_CMD()
#----------------------------#

def process_Instance_CMD(argv)
  STDOUT.puts "instance create"
end

#----------------------------#
# process_Test_CMD()
#----------------------------#

def process_Test_CMD(argv)
	if argv[0]
		worker = Worker.find(argv[1])
		log_msg = "API: Test connect to WORKER: " + worker.wrk_host + " on PORT: " + worker.wrk_port.to_s
		$log.info log_msg
		if agent_auth(worker.wrk_host, worker.wrk_port)
			return "API: Test connect SUCCESSFUL."
		else
			return "API: Test connect UN-SUCCESSFUL."
		end
	else # Display Help
		return "Usage: api test AGENT"
	end
end

def agent_auth(agentName, agentPort)
  # Connect to Worker and authenticate
  begin
		clientSession = TCPSocket.new(agentName, agentPort )
  rescue
		log_msg = "API: Cannot connect to AGENT: " + agentName
		$log.info log_msg
		return false
  else
		$log.info "API: Authenticating Connection with AGENT."
		clientSession.puts "5F3BDD56"
		agentResponse = clientSession.gets
		
		if agentResponse.include? "UNAUTHORIZED"
			$log.info agentResponse
			return false
		else
			$log.info agentResponse
			return true
		end
  end
end

##############################
# main
##############################

init_Logger("DEBUG")
$log.info "API: Starting..."
server = TCPServer.new(50001)
init_API()
$log.info "API: Waiting for call..."

#-----------------------------------#
# Loop 4ever
#-----------------------------------#

thread_count = 0

loop do
  Thread.start(server.accept)  do |session| # Wait for a connection
    
		thread_count += 1
    
    $log.info "API: Connection to SYSTEM - #{session.peeraddr[2]}"
   
    #-- BEGIN: Process Task(s)
    
    cmd = session.gets
    log_msg = "API: Command Received: " + cmd
    $log.info log_msg
    result = process_CMD(cmd.split(' '))
    log_msg = "API: Command Results: " + result
    $log.info log_msg
    session.puts result
       
    #-- END: Process Tasks
    
    # Close connection to API
    session.puts "from API: Goodbye."
    
    $log.info "API: Waiting for call..."
  end
  thread_count -= 1
end
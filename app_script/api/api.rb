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
			process_Test_CMD(argv)
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
	case argv[1]
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
	if argv[1]
		STDOUT.puts "test worker=" + argv[1]
		worker = Worker.find(argv[1])
		puts "API: Test connect to WORKER: " + worker.wrk_host + " on PORT: " + worker.wrk_port.to_s
		if agent_auth(worker.wrk_host, worker.wrk_port)
			puts "API: Test connect SUCCESSFUL."
		else
			puts "API: Test connect UN-SUCCESSFUL."
		end
	else # Display Help
		STDOUT.puts "\nUsage: api test AGENT"
	end
end

def agent_auth(agentName, agentPort)
  # Connect to Worker and authenticate
  begin
		clientSession = TCPSocket.new(agentName, agentPort )
  rescue
		puts "API: Cannot connect to AGENT: " + agentName
		return false
  else
		puts "API: Authenticating Connection with AGENT."
		clientSession.puts "5F3BDD56"
		agentResponse = clientSession.gets
		
		if agentResponse.include? "UNAUTHORIZED"
			puts agentResponse
			return false
		else
			return true
		end
  end
end

##############################
# main
##############################

init_API()
process_CMD(ARGV)
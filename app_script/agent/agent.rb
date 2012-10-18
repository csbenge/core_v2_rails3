#!/usr/bin/ruby
################################################################################
#                     Copyright @ 2012,2013 CloudDepot, Inc.                   #
#                               All Rights Reserved                            #
################################################################################

#======================================#
# Agent
#======================================#

require 'logger'
require 'popen4'
require 'socket'
require 'yaml'

#-----------------------------------#
# init_Settings
#-----------------------------------#

def init_Settings
	begin
		config      = YAML.load_file("agent_settings.yml")
	rescue
		$log.warn "AGENT: Cannot load settings."
		exit!
	end
  
	$auth_key   = config["agent"]["auth_key"]
	$port       = config["agent"]["port"]
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


init_Logger("DEBUG")
init_Settings()

$log.info "AGENT: Starting..."
begin
	server = TCPServer.new($port)
rescue Exception => e
  log_msg = "AGENT: Cannot listen on PORT: " + $port.to_s + ", MSG: " + e.message
  $log.fatal log_msg
  $log.fatal "AGENT: Exiting."
  exit 1
end
$log.info "AGENT: Ready for CMDs..."

#-----------------------------------#
# Loop 4ever
#-----------------------------------#

thread_count = 0

#loop do
#  Thread.start(server.accept)  do |session| # Wait for a connection

while (session = server.accept)   # Wait for a connection
		authenticated_connection = false
		#thread_count += 1
		#puts "***Thread Count: " + thread_count.to_s
  
    $log.info "AGENT: Connection to ENGINE - #{session.peeraddr[2]}"
    
    if authenticated_connection == false
        key = session.gets
    end
    if key.chomp == $auth_key
      authenticated_connection = true
      $log.info "AGENT:   Authenticated ENGINE - #{session.peeraddr[2]}"
      session.puts "from AGENT: CONNECTION ACCEPTED."
    else
      $log.warn "AGENT: UNAUTHORIZED CONNECTION ATTEMPT."
      session.puts "from AGENT: UNAUTHORIZED CONNECTION ATTEMPT, Goodbye."
      next
    end
    
    #-- BEGIN: Process Task(s)
    
    tasks = session.gets
    $log.info "AGENT:   CMD(s) - #{tasks}".chomp
    
    tasks.split(';').each do |task|
      
      if task[0] == "."
        result = process_dotCommands("#{task}")
        session.puts result 
        next
      end
      session.puts "CMD: " + "#{task}"
      status = POpen4::popen4("#{task}") do |stdout, stderr, stdin|  
        stdout.each do |line|
					output = "STDOUT: " + line
          session.puts output
        end
        stderr.each do |line|  
					output = "STDERR: " + line
          session.puts output
        end 
      end  
      if status == nil
        session.puts "from AGENT: Invalid CMD(s): #{tasks}"
      end
    end
    
    #-- END: Process Tasks
    
    # Close connection to Engine
    session.puts "from AGENT: Goodbye."
    authenticated_connection = false
    
    $log.info "AGENT: Waiting for CMDs..."
#  end
  
end

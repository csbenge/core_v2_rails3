################################################################################
#                     Copyright @ 2012,2013 CloudDepot, Inc.                   #
#                               All Rights Reserved                            #
################################################################################

#======================================#
# agent_test_conn
#======================================#

require 'socket'

$clientSession = nil

$agentName = 'localhost'
$agentPort = 50000

#-----------------------------------#
# agent_auth
#-----------------------------------#

def agent_auth()
  # Connect to Worker and authenticate
  $clientSession = TCPSocket.new($agentName, $agentPort )
  puts "ENGINE: Authenticating Connection with AGENT."
  $clientSession.puts "5F3BDD56"
  agentResponse = $clientSession.gets
  
  if agentResponse.include? "UNAUTHORIZED"
    puts agentResponse
    return false
  else
    return true
  end
end

#-----------------------------------#
# agent_dot_cmd
#-----------------------------------#

def agent_dot_cmd(cmd)
  $clientSession.puts cmd
  agentResponse = $clientSession.gets
  return agentResponse
end

#===================================#
# MAIN 
#===================================#

if agent_auth()
  agent_os = agent_dot_cmd('.os')
  puts "AGENT OS: " + agent_os
else
  puts "ENGINE: Could not connect to agent"
end

if agent_auth()
  agent_hostname = agent_dot_cmd('.hostname')
  puts "AGENT HOSTNAME: " + agent_hostname
else
  puts "ENGINE: Could not connect to agent"
end

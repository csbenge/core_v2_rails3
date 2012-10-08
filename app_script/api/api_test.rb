################################################################################
#                     Copyright @ 2012,2013 CloudDepot, Inc.                   #
#                               All Rights Reserved                            #
################################################################################

#======================================#
# api_test
#======================================#

require 'logger'
require 'socket'

$clientSession = nil

$apiHpst = 'localhost'
$apiPort = 50001

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
# agent_dot_cmd
#-----------------------------------#

def agent_cmd(cmd)
  $clientSession.puts cmd
  agentResponse = $clientSession.gets
  return agentResponse
end

#===================================#
# MAIN 
#===================================#

init_Logger("DEBUG")
$log.info "API_TEST: Starting..."

begin
  $clientSession = TCPSocket.new($apiHost, $apiPort)
rescue
  log_msg = "API_TEST: Cannot connect to API SERVICE: " + $apiHost + " on PORT: " + $apiPort
  $log.info log_msg
else
  result = agent_cmd('test 1')
  log_msg =  "API_TEST: " + result
  $log.info log_msg
end

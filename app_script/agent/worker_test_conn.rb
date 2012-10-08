################################################################################
#                     Copyright @ 2012,2013 CloudDepot, Inc.                   #
#                               All Rights Reserved                            #
################################################################################

#======================================#
# worker_test_conn
#======================================#

require 'socket'

$clientSession = nil

$workerName = 'localhost'
$workerPort = 50000

#-----------------------------------#
# worker_auth
#-----------------------------------#

def worker_auth()
  # Connect to Worker and authenticate
  $clientSession = TCPSocket.new($workerName, $workerPort )
  puts "ENGINE: Authenticating Connection with WORKER."
  $clientSession.puts "5F3BDD56"
  workerResponse = $clientSession.gets
  
  if workerResponse.include? "UNAUTHORIZED"
    puts workerResponse
    return false
  else
    return true
  end
end

#-----------------------------------#
# worker_dot_cmd
#-----------------------------------#

def worker_dot_cmd(cmd)
  $clientSession.puts cmd
  workerResponse = $clientSession.gets
  return workerResponse
end

#===================================#
# MAIN 
#===================================#

if worker_auth()
  worker_os = worker_dot_cmd('.os')
  puts "WORKER OS: " + worker_os
else
  puts "ENGINE: Could not connect to worker"
end

if worker_auth()
  worker_hostname = worker_dot_cmd('.hostname')
  puts "WORKER HOSTNAME: " + worker_hostname
else
  puts "ENGINE: Could not connect to worker"
end

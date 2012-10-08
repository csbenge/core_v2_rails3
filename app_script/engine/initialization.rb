################################################################################
#                     Copyright @ 2012,2013 CloudDepot, Inc.                   #
#                               All Rights Reserved                            #
################################################################################

#======================================#
# Initialization
#======================================#

require 'yaml'

require './license'
include License

module Initialization
  
  #-----------------------------------#
  # init_License
  #-----------------------------------#
  
  def init_License()
   
    lterm, lusers, lworkers   = $x_License.split("-")
    $lic = Hash.new
    $lic["term"] = lterm
    $lic["users"] = lusers
    $lic["workers"] = lworkers
    
    # print "\nLICENSE: " + lic["term"] + "-" + lic["users"] + "-" + lic["workers"]
    #print "\n\n" + decrypt_it("term", lic["term"]) + "-" + decrypt_it("users", lic["users"]) + "-" + decrypt_it("users", lic["workers"])
    # print "License:"
    # print "Term:    " + decrypt_it("term", lic["term"]) + "\n"
    # print "Users:   " + decrypt_it("users", lic["users"]) + "\n"
    # print "Workers: " + decrypt_it("workers", lic["workers"]) + "\n"
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
  # init_Settings
  #-----------------------------------#
  
  def init_Settings()
    
    config      = YAML.load_file("engine_settings.yml")
    
    $auth_key   = config["engine"]["auth_key"]
    $sleep_Interval = config["engine"]["sleep_interval"].to_i * 60
    $x_License = config["engine"]["license"]
    
  end

end


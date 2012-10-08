################################################################################
#                     Copyright @ 2012,2013 CloudDepot, Inc.                   #
#                               All Rights Reserved                            #
################################################################################

#======================================#
# API.rb - Cloud Depot API/CLI
#======================================#

#----------------------------#
# init_API()
#----------------------------#

def init_API()
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
		else # Display Help
			STDOUT.puts "\nUsage: cd_api COMMAND OPTIONS..."
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

##############################
# main
##############################

init_API()
process_CMD(ARGV)
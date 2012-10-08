#!/usr/bin/ruby

require 'rubygems'  
require 'active_record'
require 'net/ssh'
require 'sqlite3'
require 'logger'

ActiveRecord::Base.logger = Logger.new('debug.log')
ActiveRecord::Base.configurations = YAML::load(IO.read('config/database.yml'))
ActiveRecord::Base.establish_connection('development')

########################################
# User Class
########################################

class User < ActiveRecord::Base  
  def get_All_Users
    user = User.all
  end
end

########################################
# Depot Class
########################################

class Depot < ActiveRecord::Base  
  def get_All_Depot
    depots = Depot.all
  end
end

########################################
# SSH
########################################

def ssh_execute(hostname, username, password, cmd)
  begin
    ssh = Net::SSH.start(hostname, username, :password => password)
    ssh.exec!(cmd) do |ch, stream, data|    
      puts "[SSH:#{stream}>] #{data}"            
    end     
  rescue
    puts "Unable to connect to #{hostname} using #{username}/#{password}"
  end
end

########################################
# main
########################################

puts "\n***** Get Users *****"
user = User.new
users = user.get_All_Users

users.each do |u|
  puts u.name + " " + u.email 
end

puts "\n***** Get Depots *****"
depot = Depot.new
depots = depot.get_All_Depot

depots.each do |d|
  puts d.dep_name + " " + d.dep_desc + " " + d.dep_status.to_s
end

#puts "\n***** SSH to Server *****"
#ssh_execute('localhost', 'root', 'password', 'cd /tmp;ls -al;foo')


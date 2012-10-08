#!/usr/bin/jruby

require 'open3'
require 'yaml'

def lq_openProfile(profile)
  yml = YAML.load_file profile
  
#  puts "***** K/V Pair *****"
#  yml.each_pair { |key, value|
#    puts "#{key} = #{value}"
#  }
  
  yml.each_key { |key|
    $db_name          = key
    $db_driver        = yml[key]['driver']
    $db_driver_CPATH  = yml[key]['driver_CPATH']
    $db_url           = yml[key]['url']
    $db_username      = yml[key]['username']
    $db_password      = yml[key]['password']
    $db_changeLogFile = yml[key]['changeLogFile']
  }
  puts $db_name

end

def lq_generateChangeLog

=begin
  java -jar /opt/liquibase/liquibase.jar \
	--classpath=#{db_driver_CPATH} \
	--driver=#{db_driver} \
	--url=#{db_url} \
	--username=#{db_username} \
	--password=#{db_password} \
	--changeLogFile=#{db_changeLogFile} \
 	generateChangeLog
=end
end

def lq_dbDoc

  lq_cmd = "
    java -jar /opt/liquibase/liquibase.jar \
      --classpath=#{$db_driver_CPATH} \
      --driver=#{$db_driver} \
      --url=#{$db_url} \
      --username=#{$db_username} \
      --password=#{$db_password} \
      --changeLogFile=#{$db_changeLogFile} \
      dbDoc #{$db_name}_docs
  "
  stdin, stdout, stderr = Open3.popen3(lq_cmd)
  puts stdout.readlines
  puts stderr.readlines

end

lq_openProfile('testdb.yml')
lq_dbDoc

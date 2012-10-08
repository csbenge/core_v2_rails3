require "rubygems"
require "active_record"
require 'pg'
require "yaml"

ActiveRecord::Base.establish_connection(
  :adapter  => 'postgresql',
  :database => 'datical_development',
  :username => 'postgres',
  :password => 'postgres',
  :host     => 'localhost')


class Worker < ActiveRecord::Base
end

workers = Worker.all

workers.each do |worker|
  puts "WORKER_NAME: " + worker.wrk_name
  puts "WORKER_DESC: " + worker. wrk_description
end

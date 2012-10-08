
require 'net/http'
require 'uri'

=begin
uri = URI('http://localhost:3000/depots')

http    = Net::HTTP.start(uri.host, uri.port) 
request = Net::HTTP::Get.new uri.request_uri
res     = Net::HTTP.post_form(URI.parse('http://localhost:3000/login'),
                            {'user_id'=>'root', 'password'=>'password'})
puts "---------------------"
puts res
puts "---------------------"

class Api
  attr_accessor :url
  attr_accessor :uri
 
  def initialize
    @url = "http://localhost:3000/depots"
    @uri = URI.parse @url
  end
 
  def read(id=nil)
    request = Net::HTTP.new(@uri.host, @uri.port)
    #request = Net::HTTP::Get.new(@uri.request_uri)
    #request.basic_auth 'root', 'password'
 
    if id.nil?
      response = request.get("#{@uri.path}")      
    else
      response = request.get("#{@uri.path}/#{id}.xml")    
    end
 
    response.body
  end
end

###################################################

require 'nokogiri'
 
def list_depots(api_object)
  puts "Current Depots:"
  doc = Nokogiri::XML.parse api_object.read
  puts doc
  names = doc.xpath('/depots').collect {|e| e.text }
  puts names.join(", ")
  puts ""
end
 
api = Api.new
list_depots(api)

doc = Nokogiri::XML.parse api.read
ids = doc.xpath('depots/id').collect {|e| e.text }

=end

#####################################################
require 'net/http'
require 'net/https'
puts "---------------------"

http = Net::HTTP.new('localhost', 3000)
http.use_ssl = false

user = 'root'
pass = 'password'

# Log in to RT and get some data
login = "user=#{user}&pass=#{pass}"
headers = { 'Content-Type' => 'application/x-www-form-urlencoded' }
resp, data = http.post('/depots#index',login,headers)

# display what we got
puts "HTTP response code:  #{resp.code}"
puts "HTTP message: #{resp.message}"
puts "Response:"
resp.each do |key,val|
  puts "#{key} => #{val}"
end
puts "Data:"
puts data
 
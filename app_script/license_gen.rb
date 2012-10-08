################################################################################
#                     Copyright @ 2012,2013 CloudDepot, Inc.                   #
#                               All Rights Reserved                            #
################################################################################

#======================================#
# License Generator
#======================================#

require 'optparse'

#----------------------------#
# Cipher
#----------------------------#

class Cipher

  def initialize(shuffled)
    normal = ('a'..'z').to_a + ('A'..'Z').to_a + ('0'..'9').to_a + [' ']
    @map = normal.zip(shuffled).inject(:encrypt => {} , :decrypt => {}) do |hash,(a,b)|
      hash[:encrypt][a] = b
      hash[:decrypt][b] = a
      hash
    end
  end

  def encrypt(str)
    str.split(//).map { |char| @map[:encrypt][char] }.join
  end

  def decrypt(str)
    str.split(//).map { |char| @map[:decrypt][char] }.join
  end

end

def crypt_it(key, value)
	cipher = Cipher.new ["K", "D", "w", "X", "H", "3", "e", "1", "S", "B", "g", "a", "y", "v", "I", "6", "u", "W", "C", "0", "9", "b", "z", "T", "A", "q", "U", "4", "O", "o", "E", "N", "r", "n", "m", "d", "k", "x", "P", "t", "R", "s", "J", "L", "f", "h", "Z", "j", "Y", "5", "7", "l", "p", "c", "2", "8", "M", "V", "G", "i", " ", "Q", "F"]

	crypted = cipher.encrypt value
	decrypted = cipher.decrypt crypted
	
	#print "\nKEY: " + key + ", VALUE: " + value
	#print " ::  CRYPTED: " + crypted
	#print " ::  DECRYPTED: " + decrypted
	return crypted
end

def decrypt_it(key, value)
	cipher = Cipher.new ["K", "D", "w", "X", "H", "3", "e", "1", "S", "B", "g", "a", "y", "v", "I", "6", "u", "W", "C", "0", "9", "b", "z", "T", "A", "q", "U", "4", "O", "o", "E", "N", "r", "n", "m", "d", "k", "x", "P", "t", "R", "s", "J", "L", "f", "h", "Z", "j", "Y", "5", "7", "l", "p", "c", "2", "8", "M", "V", "G", "i", " ", "Q", "F"]

	decrypted = cipher.decrypt value
	return decrypted
end

#======================================#
# main
#======================================#

options = {}

optparse = OptionParser.new do |opts|
  
  opts.banner = "Usage: license_gen [ATTRIBUTES]"
  opts.separator  ""
  opts.separator  "Attributes"
  
  opts.on('-t', '--term LEN_OF_LIC', "length of license") do |i|
    options[:term] = i
  end
  opts.on('-u', '--users NUM_OF_USERS', "number of users") do |i|
    options[:users] = i
  end
  opts.on('-w', '--workers NUM_OF_WORKERS', "number of workers") do |i|
    options[:workers] = i
  end
end

begin
  optparse.parse!
  mandatory = [:term, :users, :workers]                            # Enforce the presence of
  missing = mandatory.select{ |param| options[param].nil? }        # the -t, -u and -w switches
  if not missing.empty?                                            
    puts "Missing options: #{missing.join(', ')}"                  
    puts optparse                                                  
    exit                                                           
  end                                                              
rescue OptionParser::InvalidOption, OptionParser::MissingArgument   
  puts $!.to_s                                                     # Friendly output when parsing fails
  puts optparse                                                     
  exit                                                                   
end   

lic = Hash.new
lic["term"] 		= crypt_it("term", options[:term])
lic["users"] 		= crypt_it("users", options[:users])
lic["workers"] 	= crypt_it("workers", options[:workers])

print "\nINPUT:   " + "term=" + decrypt_it("term", lic["term"]) + ", " +
											"users=" + decrypt_it("users", lic["users"]) + ", " +
											"workers=" + decrypt_it("workers", lic["workers"])

print "\nLICENSE: " + lic["term"] + "-" + lic["users"] + "-" + lic["workers"]
print "\n\n"

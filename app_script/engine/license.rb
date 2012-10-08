################################################################################
#                     Copyright @ 2012,2013 CloudDepot, Inc.                   #
#                               All Rights Reserved                            #
################################################################################

#======================================#
# Scheduler
#======================================#

module License

	class Cipher
	
		def initialize(shuffled)
			normal = ('a'..'z').to_a + ('A'..'Z').to_a + ('0'..'9').to_a + [' ']
			@map = normal.zip(shuffled).inject(:encrypt => {} , :decrypt => {}) do |hash,(a,b)|
				hash[:encrypt][a] = b
				hash[:decrypt][b] = a
				hash
			end
		end
	
		def decrypt(str)
			str.split(//).map { |char| @map[:decrypt][char] }.join
		end
	
	end
	
	def decrypt_it(key, value)
		cipher = Cipher.new ["K", "D", "w", "X", "H", "3", "e", "1", "S", "B", "g", "a", "y", "v", "I", "6", "u", "W", "C", "0", "9", "b", "z", "T", "A", "q", "U", "4", "O", "o", "E", "N", "r", "n", "m", "d", "k", "x", "P", "t", "R", "s", "J", "L", "f", "h", "Z", "j", "Y", "5", "7", "l", "p", "c", "2", "8", "M", "V", "G", "i", " ", "Q", "F"]
	
		decrypted = cipher.decrypt value
		return decrypted
	end

end


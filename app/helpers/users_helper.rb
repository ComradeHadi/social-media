module UsersHelper
	#################################################
	# method: generate_token?
	# parameter(s): 
	# return: text
	# description: generates a random token
	#################################################
	def generate_token()
		return SecureRandom.base64(15)
	end

	#################################################
	# method: salt_password
	# parameter(s): token,raw_password
	# return: text
	# description: concatenates  the token and password to salt the password
	#################################################
	def salt_password(token,raw_password)
		return Digest::SHA2.hexdigest(token + raw_password)
	end

	#################################################
	# method: validateEmail
	# parameter(s): email
	# return: boolean
	# description: validates email using regex
	#################################################
	def validateEmail(email)
		emailRegex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
		return email.present? && (emailRegex.match email)
	end
end
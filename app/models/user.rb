class User < ActiveRecord::Base
	has_many :posts, :inverse_of => :user, :dependent => :destroy

	#################################################
	# method: email_exsist?
	# parms: email
	# render: return boolean
	# description: checks if email exist
	#################################################
	def self.email_exsist?(email)
		!self.where(["email = ?",email]).blank?
	end

	#################################################
	# method: username_exist?
	# parms: username
	# render: return boolean
	# description: checks if username exist
	#################################################
	def self.username_exist?(username)
		!self.where(["username = ?",username]).blank?
	end

	#################################################
	# method: get_token
	# parms: email
	# render: token
	# description: gets the users token used in salting their password
	#################################################
	def self.get_token(email)
		self.where(["email = ?",email]).first().try('token')
	end

	#################################################
	# method: info_by_email_password
	# parms: email,salted_password
	# render: return query
	# description: gets user info
	#################################################
	def self.info_by_email_password(email,salted_password)
		self.where(["email = ? and salted_password = ?",email,salted_password]).first()
	end

	#################################################
	# method: info_by_username
	# parms: username
	# render: return query
	# description: get the first row for the username in users table
	#################################################
	def self.info_by_username(username)
		self.where(["username = ?",username]).first()
	end

	#################################################
	# method: get_user_id
	# parms: username
	# render: return query
	# description: gets user id
	#################################################
	def self.get_user_id(username)
		self.where(["username = ?",username]).first().try('id')
	end

	#################################################
	# method: get_username_by_id
	# parms: id
	# render: return query
	# description: gets user username
	#################################################
	def self.get_username_by_id(id)
		self.where(["id = ?",id]).first().try('username')
	end
end

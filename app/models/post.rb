class Post < ActiveRecord::Base
	# belongs to user model
	belongs_to	:user, :inverse_of => :posts
	# Album has many photos
	has_many :comments, :inverse_of => :post, :dependent => :destroy

	#################################################
	# method: get_all
	# parms: username
	# render: return query
	# description: gets all users post
	# todo: pagination
	#################################################
	def self.get_all(username)
		self.select("posts.*").joins(:user).where(["users.username = ?",username])
	end

	#################################################
	# method: create
	# parms: username,content
	# render: return boolean(returns true if post is created)
	# description: creates a user post
	#################################################
	def self.create(username,content)
		#gets userinfo to get his/her id and check if they exist
	    user_info = User.info_by_username(username)
	    if !user_info.blank?
			#checks if they have something to commit
			if !content.blank? 
				post = user_info.posts.new(:content => content)

	        	if post.save
	        		return true
	        	else
					return false
				end	
			else
				return false
			end	
	    else
	    	return false
	    end
	end

	#################################################
	# method: delete_post
	# parms: id,username
	# render: return boolean(returns true if post is delete)
	# description: deletes user post
	# todo: delete comments for this post
	#################################################
	def self.delete_post(id,username)
		post = self.select("*").joins(:user).where(["posts.id =  ? and username = ?",id,username])

	    if !post.blank?
			Post.delete(id)
			return true
	    else
	    	return false
	    end
	end
end

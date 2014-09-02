class Comment < ActiveRecord::Base
	# belongs to user model
	belongs_to	:post, :inverse_of => :comments

	#################################################
	# method: create_comment
	# parms: post_id,user_id,comment
	# render: return boolean(true if comment is created)
	# description: creates a comment
	#################################################
	def self.create_comment(post_id,user_id,comment)
		post = Post.where(["id =?",post_id]).first()
		if !post.blank?
			comment = post.comments.new(:user_id => user_id, :content => comment)
			if comment.save
				return true
			else
				return false
			end
		else
			return false
		end
	end

	#################################################
	# method: get_comments
	# parms: post_id
	# render: return query
	# description: gets all comments
	#################################################
	def self.get_comments(post_id)
		self.select("comments.*").joins(:post).where(["comments.post_id = ?",post_id])
	end

	#################################################
	# method: delete_comment
	# parms: comment_id,user_id
	# render: return boolean(returns true if comment is delete)
	# description: deletes user comment
	#################################################
	def self.delete_comment(comment_id,user_id)
		comment = self.where(["id = ? and user_id = ?",comment_id,user_id])

	    if !comment.blank?
			Comment.delete(comment_id)
			return true
	    else
	    	return false
	    end
	end
end

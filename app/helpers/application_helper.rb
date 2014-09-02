module ApplicationHelper
	#################################################
	# method: restricted_loggedin_redirect
	# parms: N/A
	# render: redirects
	# description: redirects to home if the user not logged in
	#################################################
	def restricted_loggedin_redirect
		if !logged_in
			redirect_to "/"
		end
	end

	#################################################
	# method: logged_in
	# parms: N/A
	# render: return boolean
	# description: checks if user is logged in
	#################################################
	def logged_in
		return !session[:username].blank? && !session[:email].blank?
	end
end

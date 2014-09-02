class UsersController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :null_session

  include UsersHelper

  layout "application"

  #################################################
  # method: login
  # parms: Username,Password
  # render: text
  # description: checks if the user has credentials to login renders empty string it not found
  #################################################
  def login
    return_ar = {}
    return_ar[:message]  = 'Invalid Username and/or Password'    
    return_ar[:error] = true

    email = params[:LoginEmail]
    password = params[:Password]

    #all parameters are set
    if !email.blank? && !password.blank?

      token = User.get_token(email)
      if !token.blank?
        salted_password = salt_password(token,password)
        if !salted_password.blank?
          user_info = User.info_by_email_password(email,salted_password)

          if !user_info.blank?
            #updates signed in on time
            user_info.signed_in_on = Time.now.getutc
            user_info.save

            #create session parameters to be used to access user data
            session[:username] = user_info.username
            session[:email] = user_info.email

            return_ar[:message] = ''
            return_ar[:error] = false
          end
        end
      end
    end

    render :json => return_ar
  end

  #################################################
  # method: logout
  # parms: N/A
  # redirects: homepage
  # description: clears session and redirects the user to the log in page
  #################################################
  def logout
    reset_session
    redirect_to "/"
  end

  #################################################
  # method: email_exsist
  # parms: Email
  # render: text
  # description: check if email exist in the database
  #################################################
  def email_exist
    email = params[:email]

    if !email.blank?
      if session[:email] == email
        render :text => ''
      else
        user_exist = User.email_exsist?(email)

        render :text => (user_exist ? 'Email already exist' : '') 
      end
    else
      render :text => ''
    end
  end

  #################################################
  # method: check_username
  # parms: Username
  # render: text
  # description: check if username exist in the database
  #################################################
  def username_exist
    username = params[:username]

    if !username.blank?
      if session[:username] == username
        render :text => ''  
      else
        user_exist = User.username_exist?(username)

        render :text => (user_exist ? 'Username already exist' : '')
      end
    else
      render :text => ''
    end
  end

  #################################################
  # method: signup
  # parms: Username,Firs,Last,Email,Password]
  # render: json
  # description: checks if there is any error and if not it create user account
  #################################################
  def signup
    return_ar = {}
    error = false

    username = params[:Username] 
    first = params[:First] 
    last = params[:Last]
    email = params[:Email]
    password = params[:Password]

    if !validateEmail(email)
      error = true
    end

    #all parameters are set
    if !username.blank? && !first.blank? && !last.blank? && !email.blank? && !password.blank? && !error

      email_exist = User.where(["email = ?",email])
      user_exist = User.where(["username = ?",username])

      if email_exist.blank? && user_exist.blank?

        token = generate_token(); 
        salted_password = salt_password(token,password)
        create_user = User.new(:username=>username,:first_name=>first,:last_name=>last,:email=>email,:token=>token,:salted_password=>salted_password,:created_on=>Time.now.getutc,:signed_in_on=>Time.now.getutc)
        create_user.save

        session[:username] = username
        session[:email] = email

        return_ar[:message] = ""
      else
        #ambiguous so it will be harder for hackers to guess
        return_ar[:message] = "Email and/or Username already exist(s)"
        return_ar[:error] = true
      end
    else
      return_ar[:errors]  = {}

      #checks if usrname is blank and if  so error will appear
      if username.blank? && return_ar[:errors][:username].blank?
        return_ar[:errors][:username] = "Parameter can't be empty."
      end

      #checks if first is blank and if  so error will appear
      if first.blank? && return_ar[:errors][:first].blank?
        return_ar[:errors][:first] = "Parameter can't be empty."
      end

      #checks if last is blank and if  so error will appear
      if last.blank? && return_ar[:errors][:last].blank?
        return_ar[:errors][:last] = "Parameter can't be empty."
      end

      #checks if email is blank and if  so error will appear
      if email.blank? && return_ar[:errors][:email].blank?
        return_ar[:errors][:email] = "Parameter can't be empty."
      end

      #checks if pasword is blank and if  so error will appear
      if password.blank? && return_ar[:errors][:password].blank?
        return_ar[:errors][:password] = "Parameter can't be empty."
      end

      return_ar[:error] = true
    end


    render :json  => return_ar

  end

  #################################################
  # method: edit
  # parms: N/A
  # render: html || redirect
  # description: allows user to edit their profile
  #################################################
  def edit
    if !session[:username].blank? && !session[:email].blank?
      @userinfo = User.info_by_username(session[:username])
    else
      redirect_to  "/"
    end
  end

  #################################################
  # method: edit_post
  # parms: username,password,email,first,last
  # render: text
  # description: allows user to edit their profile
  #################################################
  def edit_post
    return_ar = {}
    error = false
    if !session[:username].blank? && !session[:email].blank?

      username = params[:Username] 
      first = params[:First] 
      last = params[:Last]
      email = params[:Email]
      password = params[:Password]

      #validates email
      if !validateEmail(email)
        error = true
      end

      #all parameters are set
      if !username.blank? && !first.blank? && !last.blank? && !email.blank? && !error
        #checks if email and user dont exsis
        email_exist = User.where(["email = ?",email])
        user_exist = User.where(["username = ?",username])
        user_info = User.where("email = ? and username = ?",session[:email],session[:username]).first()

        if user_info.blank?
          return_ar[:message] = "Unabled to find user ID"
          return_ar[:error] = true
        else
          #checks if username and email have change
          if (session[:username] != username && !user_exist.blank?) || (session[:email] != email && !email_exist.blank?)
             #ambiguous so it will be harder for hackers to guess
            return_ar[:message] = "Email and/or Username already exist(s)"
            return_ar[:error] = true
          else
            user_info.first_name = first
            user_info.last_name = last
            user_info.email = email
            user_info.username = username

            if !password.blank? && !password.empty? && 
              salted_password = salt_password(user_info.Token,password)
              user_info.salted_password = salted_password
            end

            #updates the user data
            user_info.save

            session[:username] = username 
            session[:email] = email

             return_ar[:error] = false
            return_ar[:message] = "Updated your users information"
          end
        end
      else
        return_ar[:errors]  = {}

        #checks if usrname is blank and if  so error will appear
        if username.blank? && return_ar[:errors][:username].blank?
          return_ar[:errors][:username] = "Parameter can't be empty."
        end

        #checks if first is blank and if  so error will appear
        if first.blank? && return_ar[:errors][:first].blank?
          return_ar[:errors][:first] = "Parameter can't be empty."
        end

        #checks if last is blank and if  so error will appear
        if last.blank? && return_ar[:errors][:last].blank?
          return_ar[:errors][:last] = "Parameter can't be empty."
        end

        #checks if email is blank and if  so error will appear
        if email.blank? && return_ar[:errors][:email].blank?
          return_ar[:errors][:email] = "Parameter can't be empty."
        end

        return_ar[:error] = true
      end
    else
      return_ar[:error] = true
      return_ar[:message] = "Session has expired"
    end

    render :json  => return_ar

  end
  #################################################
  # method: search
  # parms: search
  # render: text
  # description: allows user to edit their profile
  #################################################
  def search
    s = params[:search]

    if !s.blank?
      @users_info = User.where(['(username like ?) || (first_name like ?) || (last_name like ?)',"%#{s}%","%#{s}%","%#{s}%"])
    end
  end
end

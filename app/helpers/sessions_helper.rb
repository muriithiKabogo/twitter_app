module SessionsHelper
	def log_in(user)
    session[:user_id] = user.id
 	end

  # Remembers a user in a persistent session.
  def remember(user)
    user.remember
    cookies.permanent.signed[:user_id] = user.id
    cookies.permanent[:remember_token] = user.remember_token
    debugger
  end

  def forget(user)
  end
  # Remembers a user in the database for use in persistent sessions.
  def remember
  self.remember_token = User.new_token
  update_attribute(:remember_digest, User.digest(remember_token))
  end
  

  # Returns true if the given user is the current user.
  def current_user?(user)
    user == current_user
  end

  # Returns the user corresponding to the remember token cookie.

 	def current_user
    if (user_id = session[:user_id])
      @current_user ||= User.find_by(id: user_id)
    elsif (user_id = cookies.signed[:user_id])
      user = User.find_by(id: user_id)
      if user && user.authenticated?(:remember, cookies[:remember_token])
        log_in user
        @current_user = user
      end
    end
  end
  	def logged_in?
    !current_user.nil?
  	end

  	def log_out
    session.delete(:user_id)
    @current_user = nil
    end

    # Redirects to stored location (or to the default).
    def redirect_back_or(default)
    redirect_to(session[:forwarding_url] || default)
    session.delete(:forwarding_url)
    end

  # Stores the URL trying to be accessed.
  def store_location
    session[:forwarding_url] = request.original_url if request.get?
  end


end

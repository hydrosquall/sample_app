module SessionsHelper
	# Helper functions are available in views by default, but you can add them to controllers by including SessionsHelper in Application Controller

	def sign_in(user)
		cookies.permanent[:remember_token] = user.remember_token 
		# note alt syntax cookies[:remember_token] = {value: user.remember_token, expires: 20.years.from_now.utc }
		self.current_user = user
	end

	 def signed_in_user
      unless signed_in?
        store_location
        redirect_to signin_path, notice: "Please sign in."
      end
      # notice condensed versoin of = flash[:notice] ="Please Sign in"
      # redirect_to signin_path. Works for error key, but not for success.
    end

	def current_user=(user)
		@current_user = user
	end

	def current_user
		@current_user ||= User.find_by_remember_token(cookies[:remember_token]) # only assigns if the variable is currently undefined
	end

	def current_user?(user)
		user == current_user
	end

	def signed_in?
		!current_user.nil?
	end

	def sign_out
		self.current_user = nil
		cookies.delete(:remember_token)
	end

	def redirect_back_or(default)
		redirect_to(session[:return_to] || default)
		session.delete(:return_to)
	end

	def store_location
		session[:return_to] = request.fullpath #stores current page location full filepath
	end
end

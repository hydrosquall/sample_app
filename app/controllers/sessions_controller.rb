class SessionsController < ApplicationController
	def new
	end

	def create
		#user = User.find_by_email(params[:session][:email])
		user = User.find_by_email(params[:email])

		#if user && user.authenticate(params[:session][:password] )
		if user && user.authenticate(params[:password] )
			session[:user] = user.id
			sign_in user
			redirect_back_or user
		else
			#.now version of flash won't persist to other pages
			flash.now[:error] = "Invalid email/password combination "# not quite right!
			render 'new'
		end

	end

	def destroy
		sign_out
		redirect_to root_path
	end
end

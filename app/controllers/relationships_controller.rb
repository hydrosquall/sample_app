class RelationshipsController < ApplicationController
	before_filter :signed_in_user

	def create
		@user = User.find(params[:relationship][:followed_id])
		current_user.follow!(@user)
		#redirect_to @user  non ajax implemntation

		#syntax of respond-to- only one lines gest called.
		respond_to do |format|
			format.html { redirect_to @user }
			format.js
		end
	end

	def destroy
		@user = Relationship.find(params[:id]).followed
		current_user.unfollow!(@user)
		# redirect_to @user non ajax form

		respond_to do |format|
			format.html { redirect_to @user }
			format.js
		end
	end

end
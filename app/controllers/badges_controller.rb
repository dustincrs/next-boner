class BadgesController < ApplicationController

	def show
		@user = User.includes(:badges).find_by_id(params[:user_id])
	end

end

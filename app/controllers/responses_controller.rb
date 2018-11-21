class ResponsesController < ApplicationController
	before_action :require_login
	before_action :get_associated_project, only: [:show]

	def show
	end

	def create
		new_response = Response.new(user_id: current_user.id, project_id: response_params[:project_id])

		if(new_response.save)
			flash[:success] = "Response saved! Thank you for volunteering!"
		else
			flash[:error] = "Couldn't save that response, #{new_response.errors.full_messages.join(", ")}"
		end

		redirect_to project_path(response_params[:project_id])
		
	end

	private
	def get_associated_project
		@project = Project.find_by_id(params[:id])
	end

	def response_params
		params.permit(:project_id)
	end
end
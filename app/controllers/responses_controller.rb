class ResponsesController < ApplicationController
	before_action :require_login
	before_action :disallow_moderator, only: [:create, :new, :show]
	before_action :get_associated_project, only: [:show]
	before_action :get_response, only: [:update]

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

	def update
		# Make is_hidden to true
		if(params[:_method]=="patch")
			@response.is_hidden = true
			@response.is_approved = false
			@response.save!

		elsif(params[:_method]=="put")
			@response.is_approved = true
			@response.save!
		end

		redirect_to project_path(@response.project)
	end

	private
	def get_associated_project
		@project = Project.find_by_id(params[:id])
	end

	def get_response
		@response = Response.find_by_id(params[:id])
	end

	def response_params
		params.permit(:project_id)
	end
end
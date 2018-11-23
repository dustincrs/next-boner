class ReviewsController < ApplicationController
  def new
  	@project = Project.find_by_id(params[:project_id])
  	@user = User.find_by_id(params[:user_id])
  end

  def create
  	new_review = Review.new(review_params)

  	if(new_review.save)
  		flash[:success] = "Successfully reviewed #{new_review.user.full_name}!"
  	else
  		flash[:error] = "Failed to submit review! #{new_review.errors.full_messages.join(", ")}"
  	end
  	
	redirect_to project_path(new_review.project.id)
  end

  def show
    @review = Review.find_by_id(params[:review_id])
    @project = @review.project
    @volunteer = @review.user
    @poster = @project.user
  end

  def display
    @user = User.find_by_id(params[:user_id])
  end

  private
  def review_params
  	params.require(:review).permit(:project_id, :user_id, :rating, :text)
  end
end

class ReviewsController < ApplicationController
  def new
    @project = Project.find_by_id(params[:project_id])
    @user = User.find_by_id(params[:user_id])
  end

  def create
    @new_review = Review.new(review_params)
    @new_review.rating = 0 if (@new_review.rating.nil? == true)

    @save_success = @new_review.save

    respond_to do |format|
      format.js {render 'reviews/on_form_submit'}
    end
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

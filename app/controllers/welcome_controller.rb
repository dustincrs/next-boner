class WelcomeController < ApplicationController
  def index
    @projects = Project.where(is_complete: false).order(created_at: :desc).limit(10)
  end
end

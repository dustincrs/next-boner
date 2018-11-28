class WelcomeController < ApplicationController
  def index
    @projects = Project.where(is_complete: false)
  end
end

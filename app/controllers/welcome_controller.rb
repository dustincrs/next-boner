class WelcomeController < ApplicationController
  def index
    @projects = Project.where(is_complete: false).limit(4)
  end
end

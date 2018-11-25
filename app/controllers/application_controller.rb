class ApplicationController < ActionController::Base
  include Clearance::Controller


  private

  def disallow_moderator
    if(current_user.moderator?)
      flash[:notice] = "Moderators cannot do that action! Bad boy."
      redirect_to root_path
    end
  end

end

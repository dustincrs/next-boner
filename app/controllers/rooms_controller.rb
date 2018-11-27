class RoomsController < ApplicationController
  before_action :require_login
  before_action :set_chatroom, only: [:show]

  def index
    @chatrooms = Chatroom.all
  end

  def show
    
    # @s = Chatroom.find_by_id(params[:id]) 
    # if @chatroom
    # else
    #   Chatroom.new(name: "Chat between #{current_user.full_name} and #{target_user.full_name}")
    # end
    # @messages = Message.all
    @messages = Message.where(chatroom_id: @chatroom)
  end

  def create
    target_user = User.find_by_id(chatroom_params[:format])
    @chatroom = Chatroom.new(name: "Chat between #{current_user.full_name} and #{target_user.full_name}")

    if @chatroom.save
      Chatroom.transaction do
        current_user.subscriptions.create(chatroom_id: @chatroom.id)
        target_user.subscriptions.create(chatroom_id: @chatroom.id)
      end
    end
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_chatroom
      @chatroom = Project.find_by_id(params[:id]).chatroom
      
      
    end

    def chatroom_params
      params.permit(:format)
    end

end

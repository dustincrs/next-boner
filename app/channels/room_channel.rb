class RoomChannel < ApplicationCable::Channel
  def subscribed
    stream_from "room_channel_#{params[:chatroom_id]}"
  end
  
  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
  
  def speak(data)
    ActionCable.server.broadcast "room_channel_#{params[:chatroom_id]}", message: data['message']
    message = Message.new(content: data['message'])
    # message.user_id = @bootleg_id.scan(/\d+/)[0]
    message.user_id = data['id'].scan(/\d+/)[0]
    message.chatroom_id = params[:chatroom_id] #this is where the problem is***
    message.save
  end
end

# params
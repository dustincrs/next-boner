class RoomChannel < ApplicationCable::Channel 
  def subscribed
    stream_from "room_channel_#{params[:chatroom_id]}"
  end
  
  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
  
  def speak(data)
    message = Message.new(content: data['message'])
    # message.user_id = @bootleg_id.scan(/\d+/)[0]
    message.user_id = data['id'].scan(/\d+/)[0]
    message.chatroom_id = params[:chatroom_id] #this is where the problem is***
    message.save
    
    first_name = User.find_by_id(message.user_id).first_name
    avatar = User.find_by_id(message.user_id).avatar.url.to_s
    ActionCable.server.broadcast "room_channel_#{params[:chatroom_id]}", message: data['message'], user_fname: first_name, user_avatar: avatar
  end
end

# params
class RoomChannel < ApplicationCable::Channel
  def subscribed
    stream_from "room_channel"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def speak(data)
    ActionCable.server.broadcast "room_channel", message: data['message']
    message = Message.new(content: data['message'])
    # message.user_id = @bootleg_id.scan(/\d+/)[0]
    message.user_id = data['id'].scan(/\d+/)[0]
    message.save
    
  end
end

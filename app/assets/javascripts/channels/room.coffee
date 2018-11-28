$(document).ready ->
  # x = document.querySelector(".messages");
  x = document.getElementById("messages");
  console.log(x);

  bootleg_id = document.getElementById("msg").innerHTML;
  chatroom_id = document.querySelector("#chatroom_id").innerHTML;
  # console.log(chatroom_id)

  App.room = App.cable.subscriptions.create {channel: "RoomChannel", chatroom_id: chatroom_id},

    scroll_bottom = () ->
      $('#messages').scrollTop($('#messages')[0].scrollHeight)

    connected: ->
      # Called when the subscription is ready for use on the server
      scroll_bottom();

    disconnected: ->
      # Called when the subscription has been terminated by the server
    received: (data) ->
      # alert(data['message'])
      # Called when there's incoming data on the websocket for this channel
      console.log(data)
      y = document.createElement("div");
      y.innerHTML = "<p>#{data.user_fname} says: </p> <p>#{data.message}</p>"
      # img src =\"data.user_avatar\"/>
      x.append(y);
      scroll_bottom();


    speak: (message)->
      # console.log(bootleg_id)
      @perform 'speak', message: message, id: bootleg_id, chatroom_id: chatroom_id
      

$(document).on 'keypress', '[data-behavior~=room_speaker]', (event) ->
  if event.keyCode is 13 # return/enter = send
    App.room.speak event.target.value
    event.target.value = ''
    event.preventDefault()
    # scroll_bottom()


    submit_message = () ->
  $('#message-input').on 'keydown', (event) ->
    if event.keyCode is 13
      $('#message-input').click()
      event.target.value = ""
      event.preventDefault()

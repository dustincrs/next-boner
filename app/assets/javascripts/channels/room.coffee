$(document).ready ->
  x = document.querySelector(".inner");
  bootleg_id = document.getElementById("msg").innerHTML;

  chatroom_id = document.querySelector("#chatroom_id").innerHTML;
  console.log(chatroom_id)

  App.room = App.cable.subscriptions.create {channel: "RoomChannel", chatroom_id: chatroom_id},

    connected: ->
      # Called when the subscription is ready for use on the server

    disconnected: ->
      # Called when the subscription has been terminated by the server
    received: (data) ->
      # alert(data['message'])
      # Called when there's incoming data on the websocket for this channel
      y = document.createElement("div");
      y.innerHTML = data.message;
      x.append(y);


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

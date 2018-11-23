$(document).ready ->
  x = document.querySelector(".inner");
  bootleg_id = document.getElementById("msg").innerHTML;
  App.room = App.cable.subscriptions.create "RoomChannel",
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
      @perform 'speak', message: message, id: bootleg_id
      

$(document).on 'keypress', '[data-behavior~=room_speaker]', (event) ->
  if event.keyCode is 13 # return/enter = send
    App.room.speak event.target.value
    event.target.value = ''
    event.preventDefault()
$(document).ready ->
  x = document.getElementById("messages");
  console.log(x);

  if (document.getElementById("msg") && document.querySelector("#chatroom_id"))
    bootleg_id = document.getElementById("msg").innerHTML;
    chatroom_id = document.querySelector("#chatroom_id").innerHTML;
  

  # console.log(chatroom_id)

  # scroll_bottom = () ->
  #   $('#messages').scrollTop($('#messages')[0].scrollHeight)
    
  App.room = App.cable.subscriptions.create {channel: "RoomChannel", chatroom_id: chatroom_id},

    received: (data) ->
      # alert(data['message'])
      # Called when there's incoming data on the websocket for this channel
      # console.log("data")
      # y = document.createElement("div");

        y = document.querySelector("card-body")
        console.log(y)
        y.innerHTML = "<p>#{data.user_fname} says: </p> <p>#{data.message}</p>"
        x.append(y);
      # scroll_bottom();


    speak: (message)->
      # console.log(bootleg_id)
      @perform 'speak', message: message, id: bootleg_id, chatroom_id: chatroom_id
      

$(document).on 'keypress', (event) ->
  if event.keyCode is 13 # return/enter = send
    App.room.speak event.target.value
    event.target.value = ''
    event.preventDefault()
    # scroll_bottom();



$ ->
  chat_id = $("#channel_id").val()
  chatMessageTemplate = """<li class='left clearfix'>
    <span class='chat-img pull-left'>
    <img alt='User Avatar' class='img-circle' src='http://placehold.it/50/55C1E7/fff&text=U'/>
    </span>
    <div class='chat-body clearfix'>
      <div class='header'>
        <strong class='primary-font'>Jack Sparrow</strong>
        <small class='pull-right text-muted'>
          <span class='glyphicon glyphicon-time'>12 mins ago</span>
        </small>
    </div>
      <p>{{message}}</p>
    </div>
    </li>
    """
  socket = io.connect('http://0.0.0.0:5001')
  socket.emit('join', chat_id)
  socket.on 'chat_message', (message) ->
    $("ul.chat").append(chatMessageTemplate.replace("{{message}}", message.content))

  $("#btn-chat").on "click", ->
    console.log("button clicked!")

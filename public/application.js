$(function() {

  $('#chat_form').on('submit', function(e) {
    e.preventDefault();
    
    var username = $('#username').val();
    var message = $('#message').val();
    var since = $('#since').val();
    // console.log('did i get here?' + username + since + message);

    $.ajax({
      url: "chat",
      type: 'POST',
      data: { username: username, message: message, since: since },
      success: function(data) {

        // console.log(data);
        $.each(data, function(i, message){
          var htmlstring = '<li id="chatlist"><span title="' + message.timestamp + '"><span class="username">' + message.username + '</span><span class="message">' + message.message + '</span></span></li>';
          $('.chat').prepend(htmlstring);
        });
        $('#since').val(data[data.length-1].timestamp);
        // $('#message').val('')
      },
      complete: function(response) {
        $('#username').val(' ');
        $('#message').val(' ');
        // console.log(response.responseText);
      }
    });
  });
});
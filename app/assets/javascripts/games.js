

  var pollNewPlayers = function(path){
    console.log('in poll new players');
    // $.get("<%= game_waiting_for_game_to_start_path(game_id: @game.id, player_id: @player.id) %>"), function(data){
    //   console.log('in get function')
    // };

    $.ajax({
      type: 'get',
      dataType: 'json',
      url: path,
      success: function(data){
        console.log('success');
        if (data.status == 'wait'){
          console.log('status: ' + data['status'])
          $('#main-content').html(data['html']);
          serverPoller = setTimeout(pollNewPlayers, 2000);

        }
        if (data.status == 'continue') {
          console.log('in continue')
          $.ajax({
            type: 'get',
            dataType: 'json',
            url: data.new_path,
            success: function(data){
              console.log('in continue success function')
              $('body').html(data.html)
            }
          });

        }

      }
    })
  };






  var startGame = function(){
    console.log('in start game')
    clearTimeout(serverPoller);
    var path = $('#new-path').html();
    $.ajax({
      type: 'get',
      dataType: 'json',
      url: path,
      success: function(data){
        console.log('in continue success function')
        $('body').html(data.html)
      }
    });
  };



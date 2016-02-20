

  var pollServer = function(path){
    console.log('in poll new players');
    clearTimeout(serverPoller);

    $.ajax({
      type: 'get',
      dataType: 'json',
      url: path,
      success: function(data){
        console.log('success');
        if (data.status == 'wait'){
          console.log('status: ' + data['status'])
          $('body').html(data.html);
          serverPoller = setTimeout(function(){pollServer(path)}, 2000);

        }
        if (data.status == 'continue') {
          console.log('in continue')
          $.ajax({
            type: 'get',
            dataType: 'json',
            url: data.new_path,
            success: function(data){
              console.log('in continue success function')
              $('body').html(data.html);
              if (data.continue_polling){
                pollServer(data.path)
              }
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



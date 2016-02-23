

  var pollServer = function(path){
    console.log('in pollServer path: ' + path);
    clearTimeout(serverPoller);

    $.ajax({
      type: 'get',
      dataType: 'json',
      url: path,
      success: function(data){
        console.log('success in initial ajax call for path: ' + path);
        console.log('data packet: ' + data)
        if (data.status == 'wait'){
          console.log('im wait of initial ajax call: ' + data['status'])
          $('body').html(data.html);
          serverPoller = setTimeout(function(){pollServer(path)}, 2000);
        }
        if (data.status == 'continue') {
          console.log('in continue of initial ajax call, ')
          $.ajax({
            type: 'get',
            dataType: 'json',
            url: data.next_path,
            success: function(data){
              console.log('in continue success function')
              $('body').html(data.html);
              if (data.continue_polling){
                pollServer(data.current_path)
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

  var pickQuestion = function(){
    console.log('in pick question')
    var path = $('#next-path').html()
    pollServer(path);
    // $.ajax({
    //   type: 'get',
    //   dataType: 'json',
    //   url: path,
    //   success: function(data){

    //   }
    // })
  };

  var selectAnswer = function(answerID){
    console.log('in select answer');
    $('#hidden-submit-button').show();
    $('#hidden-selection-id').html(answerID);
    var answerText = $('#'+answerID).html()
    $('#selected-response').html(answerText)
  };

  var submitAnswer = function(){
    var answerID = $('#hidden-selection-id').html();
    nextPath = $('#next-path').html();
    $.ajax({
      type: 'get',
      url: nextPath,
      dataType: 'json',
      data: {answer_id: answerID},
      success: function(data){
        console.log('in submit answer success')
        $('body').html(data.html);
        if (data.continue_polling){
          pollServer(data.current_path)
        }
      }
    });
  }

  var proceedToNextRound = function(){
    nextPath = $('#next-path').html();
    pollServer(nextPath);
  }



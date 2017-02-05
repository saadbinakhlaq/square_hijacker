App.game = App.cable.subscriptions.create("GameChannel", {
  connected: function() {
    // Called when the subscription is ready for use on the server
  },

  disconnected: function() {
    // Called when the subscription has been terminated by the server
  },

  received: function(data) {
    // Called when there's incoming data on the websocket for this channel
    var time = Number($('#blockage-time').data()['blockageTime']);

    if (data.game_ends) {
      $('#winner').text(data.winner_name);
    }

    if (data.enable_squares) {
      this.enableAllSqaures();
    }

    if (data.block) {
      this.disableAllSquares();
      shared.clock(
        $('#clock'),
        time
      );

      var self = this;
      setTimeout(
        function() {
          self.enableSquares(data.unclaimed_squares);
          self.fillClaimedSquare(data.disabled_square_id, data.disabled_square_colour);
        },
        time * 1000
      );
    }
  },

  enableAllSqaures: function() {
    $(':submit').each(function() {
      $(this).removeAttr('disabled');
    });
  },

  disableAllSquares: function() {
    $(':submit').each(function() {
      $(this).attr('disabled', 'disabled');
    });
  },

  showClock: function() {
    var time = $('#blockage-time').data()['blockageTime'];
    shared.clock($('#clock'), Number(time));
  },

  enableSquares: function(array) {
    console.log(array)
    $.each(array, function(index) {
      var submit = $('#edit_square_' + array[index]).find(':submit');
      submit.removeAttr('disabled');
    });    
  },

  fillClaimedSquare: function(claimedSquare, colour) {
    var $player = $('#player');
    var $claimedSquare = $('#square-' + claimedSquare);
    $claimedSquare.removeAttr('data-unclaimed');
    $claimedSquare.attr('data-claimed', $player.data('playerid'));
    $claimedSquare.find('input[type=submit]').css('background', '')
    $claimedSquare.css('background', colour);
  }
});

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
      this.addWinner(data.winner_name);
    }

    if (data.enable_squares) {
      this.enableAllSqaures();
    }

    if (data.player_joined) {
      this.addPlayer(data.joining_player_id, data.joining_player_name, data.joining_player_colour);
    }

    if (data.block) {
      this.disableAllSquares();
      shared.clock(
        $('#clock'),
        time
      );

      this.updatePlayerScore(data.player_id, data.player_score);

      var self = this;
      setTimeout(
        function() {
          self.enableSquares(data.unclaimed_squares);
          self.fillClaimedSquare(data.disabled_square_id, data.disabled_square_colour);
          self.removeButtonColor();
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
  },

  removeButtonColor: function() {
    $('input[type=submit]').each(function() {
      $(this).css('background', '');
    });
  },

  updatePlayerScore: function(player_id, score) {
    $('.player-menu').find('#player-score-' + player_id).text(score);
  },

  addPlayer: function(playerId, name, colour) {
    var $playersMenu = $('#players');
    $playersMenu.append('<li class="pure-menu-item">' +
                          '<div class="pure-menu-link player-menu-item" style="background: ' + colour + '">' + 
                            '<span class="player-menu-item__name">' + name + '</span>' +
                            '<span class="player-menu-item__score float-right" id="player-score-' + playerId + '"> ' + 0 + '</span>' +
                          '</div>' +
                        '</li>');
  },

  addWinner: function(name) {
    $('#winner').append('<p id="winner-name">Player: ' + name +' wins the game</p>')
  }
});

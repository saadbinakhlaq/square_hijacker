SITENAME.games = {
  init: function() {
  },
  show: function() {
    this.colourSquaresOnHover();
  },
  colourSquaresOnHover: function() {
    var $squares = $('.squares').find('.square[data-unclaimed]');
    var $player  = $('#player');

    $squares.hover(
      function() {
      // $squares.find('input[type=submit]:enabled').css('background-color', $player.data()['colour'])
      $squares.each(function() {
        $(this).find('input[type=submit]:enabled').css('background', $player.data()['colour'])
      })
    },
      function() {
      // $squares.find('input[type=submit]:enabled').css('background-color', '')
      $squares.each(function() {
        $(this).find('input[type=submit]:enabled').css('background', '')
      })
    })
  }
}
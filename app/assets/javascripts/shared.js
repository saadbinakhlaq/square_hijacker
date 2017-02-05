shared = {
  clock: function($elem, countDownTime) {
    for(var i = countDownTime; i >= 0; i--) {
      var timeInterval = (countDownTime - i) * 1000;
      (function(iCopy){
        setTimeout(function() {
          var text = iCopy;
          $elem.text(iCopy);
        }, timeInterval);
      })(i);
    }
  }
}
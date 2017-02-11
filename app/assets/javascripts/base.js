SITENAME = {
  common: {
    init: function() {
      var flashMessage = $('#flash');

      if (!!flashMessage) {
        setTimeout(function() {
          flashMessage.fadeOut('slow');
        }, 2000)
      }
    }
  }
};

UTIL = { 
  exec: function( controller, action ) { 
    var ns = SITENAME, 
    action = ( action === undefined ) ? "init" : action; 

    if ( controller !== "" && ns[controller] && typeof ns[controller][action] == "function" ) { 
      ns[controller][action](); 
    } 
  }, 
  init: function() { 
    var body       = document.body, 
        controller = body.getAttribute( "data-controller" ),
        action     = body.getAttribute( "data-action" );

    UTIL.exec( "common" ); 
    UTIL.exec( controller ); 
    UTIL.exec( controller, action ); 
  } 
}; $( document ).ready( UTIL.init );
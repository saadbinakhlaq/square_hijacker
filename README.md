# A real time game where player compete to hijack squares in a grid

### Install
* clone the repo
* cd in to the directory and do `bundle install`
* `rake db:create`
* `rake db:migrate`
* run the tests `rake`
* `bundle exec rails server` to spin up a rails server
* by default the application will be available on localhost:3000
* sign in and play the game
* by default two players are required to start the game

### Rules of the game
* The game starts when 2 players join the game
* When a player selects a square the board becomes disabled for `x` number of seconds
* When the board is enabled again any of the player can hijack a square
* Player with max number of square wins the game.


##### TODO
Make the number of players, game disabled time and number of squares configurable.
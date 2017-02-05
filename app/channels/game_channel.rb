class GameChannel < ApplicationCable::Channel
  def subscribed
    # stream_from "some_channel"
    stream_from 'game_channel'
    stream_from "game_channel_user_#{current_user.id}"

    Game.for_user(current_user.id).each do |game|
      stream_from "game_channel_#{game.id}"
      stream_from "game_channel_#{game.id}_user_#{current_user.id}"
    end
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end

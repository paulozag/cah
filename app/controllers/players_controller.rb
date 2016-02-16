class PlayersController < ApplicationController
  def new
    player = Player.create(game_id: params[:game_id], user_id: current_user.id)
    redirect_to game_waiting_for_game_to_start_path(game_id: params[:game_id], player_id: player.id)
  end
end

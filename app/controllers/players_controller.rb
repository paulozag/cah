class PlayersController < ApplicationController
  def new
    player = Player.create(game_id: params[:game_id], user_id: params[:user_id])
    redirect_to new_game_player_round_path(game_id: params[:game_id], player_id: player.id)
  end
end

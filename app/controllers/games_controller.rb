class GamesController < ApplicationController

  def new
    @game = Game.new(creator_id: current_user.id)
  end

  def create
    @game = Game.new(game_params)
    respond_to do |format|
      if @game.save
        @game.rounds.create(round_number: @game.round_number, judge_id: params[:creator_id])
        @game.players.create(user_id: current_user.id)
        format.html { redirect_to game_player_round_launch_path() }
      else
        format.html {render 'new'}
      end
    end
  end

  private
  def game_params
    params.require(:game).permit(:game_key, :creator_id)
  end


end

class GamesController < ApplicationController

  def new
    @game = Game.new(creator_id: current_user.id)
  end

  def create
    @game = Game.new(game_params)
    @game.judge_id = current_user.id

    respond_to do |format|
      if @game.save
        @game.rounds.create(round_number: @game.round_number, judge_id: @game.judge_id)
        @player = @game.players.create(user_id: current_user.id)
        format.html { redirect_to new_game_player_round_path(@game, @player) }
      else
        format.html {render 'new'}
      end
    end
  end

  def index
    @user_id = params[:user_id]
    if params[:game_id_selected]
      redirect_to new_game_player_path(game_id: params[:game_id_selected], user_id: params[:user_id])
    end
    @games = Game.all.ready_for_players
  end

  def add_player

  end

  private
  def game_params
    params.require(:game).permit(:game_key, :creator_id)
  end


end

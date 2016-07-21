class GamesController < ApplicationController

  def new
    @game = Game.new(creator_id: current_user.id)
  end

  def create
    @game = Game.create(game_params)
    @player = @game.players.create(user_id: current_user.id)
    @round = @game.rounds.create(round_number: @game.round_number, judge_id: @player.id)
    @game.judge_id = @player.id
    @game.creator_id = current_user.id
    @game.save
    respond_to do |format|
      format.html { redirect_to game_waiting_for_game_to_start_path(@game, player_id: @player.id, round_id: @round.id ) }
    end
  end

  def index
    @user_id = params[:user_id]
    @games = Game.all.ready_for_players
    if params[:game_id_selected]
      @game = Game.find(params[:game_id_selected])
      if @game.game_key == params[:game_key]
        redirect_to new_game_player_path(game_id: params[:game_id_selected], user_id: params[:user_id])
      else
        render 'index'
      end
    end

  end

  def waiting_for_game_to_start
    @game = Game.find(params[:game_id])
    @player = Player.find(params[:player_id])
    @round = @game.rounds.last

    status = @game.status == 'playing' ? 'continue' : 'wait'
    next_path = game_player_round_draw_card_path(game_id: @game.id, player_id: @player.id, round_id: @round.id)

    data = {status: status, html: (render_to_string 'waiting_for_game_to_start'), next_path: next_path}

    respond_to do |format|
      format.json {render json: data}
      format.html {render :waiting_for_game_to_start}
    end
  end





  private
  def game_params
    params.require(:game).permit(:game_key, :creator_id, :point_limit)
  end


end

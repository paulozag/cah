class RoundsController < ApplicationController
  before_action :set_instance_variables_from_route, except: [:new]

  def new

  end

  def draw_card
    # expects: game, player, round instance variables
    #
    # judge
    #   render pick_a_question
    # player
    #   status pending until question is picked
    #   render display_question
    if @game.status == 'loading'
      @game.status = 'playing'
      @game.save
      @game.start_game
    end

    @judge = judge?
    @current_path = game_player_round_draw_card_path(game_id: @game.id, player_id: @player.id, round_id: @round.id)
    @next_path = game_player_round_question_displayed_path(game_id: @game.id, player_id: @player.id, round_id: @round.id)

    status = @round.question_card_id ? 'continue' : 'wait'
    p '%^%' * 300
    p "status #{status}"
    p "continue polling: #{!judge?}"
    data = {html: (render_to_string  'draw_card'), continue_polling: !judge?, next_path: @next_path, status: status, current_path: @current_path}

    respond_to do |format|
      format.json {render json: data}
    end
  end

  def  question_displayed
    unless @round.question_card_id
      @round.question_card_id = (@game.draw_question_card).id
      @round.save
    end

    @current_path = game_player_round_question_displayed_path(game_id: @game.id, player_id: @player.id, round_id: @round.id)
    @next_path = game_player_round_submit_answers_path(game_id: @game.id, player_id: @player.id, round_id: @round.id)
    @question = QuestionCard.find(@round.question_card_id)
    status = @round.player_answers.count == @game.players.count - 1 ? 'continue' : 'wait'


    data = {status: status, html: (render_to_string  'display_question'), current_path: @current_path, next_path: @next_path, continue_polling: judge?}
    respond_to do |format|
      format.json {render json: data}
    end
  end

  def submit_answers
    @current_path = game_player_round_submit_answers_path(game_id: @game.id, player_id: @player.id, round_id: @round.id)
    @next_path = game_player_round_select_winner_path(game_id: @game.id, player_id: @player.id, round_id: @round.id)
    register_player_answer params[:answer_id] if params[:answer_id]

    data = {status: 'wait', html: (render_to_string  'submit_answers')}
    respond_to do |format|
      format.json {render json: data}
    end

  end

  def select_winner
    # expects: game, player, round instance variables
    #
    # judge
    #   status pending until all answers submitted
    #   render choose_winner
    #
    # if player
    # => status pending until winner is selected
    # => render summary
  end

  def summary
    # expects: game, player, round instance variables
    #
    # judge
    #   receive id of winning answer
    #   update round, check game winning criteria,
    #
    #   create new round, assign next judge, increment game.round_number
    #   render summary
    # player
    #   player never gets here - player is rendered summary directly from select_winner
  end


  private

  def set_instance_variables_from_route
    @game = Game.find(params[:game_id])
    @player = Player.find(params[:player_id])
    @round = @game.rounds.last
    @judge = judge?
  end

  def judge?

    @player.id ==  @round.judge_id
  end

  def register_player_answer(answer_id)
    @round.player_answers[@player.id] = answer_id
    @round.save
  end

end

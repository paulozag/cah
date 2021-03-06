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
    @next_path = game_player_round_summary_path(game_id: @game.id, player_id: @player.id, round_id: @round.id)
    register_player_answer params[:answer_id] if params[:answer_id]
    status = @round.answer_card_id ? 'continue' : 'wait'

    data = {status: status, html: (render_to_string  'submit_answers'), continue_polling: !judge?, current_path: @current_path, next_path: @next_path}
    respond_to do |format|
      format.json {render json: data}
    end
  end

  def summary
    finalize_round params[:answer_id] if params[:answer_id]
    # check winning conditions
    @current_path = game_player_round_summary_path(game_id: @game.id, player_id: @player.id, round_id: @round.id)
    @next_path = game_player_round_draw_card_path(game_id: @game.id, player_id: @player.id, round_id: @game.rounds.last.id)
    data = {status: 'wait', html: (render_to_string  'summary'), continue_polling: false, current_path: @current_path, next_path: @next_path}

    respond_to do |format|
      format.json {render json: data}
    end
  end

  def game_summary

  end
  private

  def set_instance_variables_from_route
    @game = Game.find(params[:game_id])
    @player = Player.find(params[:player_id])
    if params[:round_id]
      @round = Round.find(params[:round_id])
    else
      @round = Game.rounds.last
    end
    @judge = judge?
  end

  def judge?

    @player.id ==  @round.judge_id
  end

  def register_player_answer(answer_id)
    @round.player_answers[@player.id] = answer_id
    @round.save
  end

  def finalize_round(answer_id)
    @round.answer_card_id = answer_id
    @round.winner_id = AnswerCard.find(answer_id).player.id
    @round.save
    move_question_card_to_winners_hand
    move_played_answer_cards_to_discard_pile

    if game_won?
      redirect_to games/game_summary
    end
    deal_new_answer_cards_to_players
    create_next_round
  end

  def move_played_answer_cards_to_discard_pile
    @round.player_answers.each do |player_id, answer_card_id|
      card = AnswerCard.find(answer_card_id)
      card.player_id = nil
      card.answer_discard_pile_id = @game.answer_discard_pile.id
      card.save
    end
  end

  def move_question_card_to_winners_hand
    card = @round.question_card
    card.question_deck_id = nil
    card.player_id = @round.winner_id
    card.save
  end

  def create_next_round
    @game.round_number += 1
    @game.save
    @game.rounds.create(round_number: @game.round_number, judge_id: select_next_judge)
  end

  def select_next_judge
    player_count = @game.players.count
    judge_index = ((@game.round_number) -1) % player_count
    @game.players[judge_index].id
  end

  def game_won?
    @game.players.each do |player|
      player.question_cards.count

      if player.question_cards.count >= 2
        @game.winner_id = player.id
        return true
      end
    end
    false
  end


  def deal_new_answer_cards_to_players
    @game.players.each do |player|
      (10 - player.answer_cards.count).times do
        card = @game.draw_answer_card
        card.player_id = player.id
        card.save
      end
    end
  end

end

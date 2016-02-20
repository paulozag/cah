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

    @judge = judge?
    @path = game_player_round_question_displayed_path(game_id: @game.id, player_id: @player.id, round_id: @round.id)

    if @game.status == 'loading'
      @game.status = 'playing'
      @game.save
      @game.start_game
    end

    data = {html: (render_to_string  'draw_card')}

    respond_to do |format|
      format.json {render json: data}
    end
  end

  def  question_displayed
    # expects: game, player, round instance variables
    #
    # judge
    #   generates new question
    #   renders waiting_for_all_answers_to_come_in
    # player
    #   receives player submission and updates round values
    #   render waiting_for_winner_page
    unless @round.question_card_id
      @round.question_card_id = (@game.draw_question_card).id
      @round.save
    end
    data = {status: 'good'}
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
  end

  def judge?
    @player.id ==  @round.judge_id

  end
end

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
    round_id = params[:round_id] || params[:id]
    @round = Round.find(@game.round_number)
  end

  def judge?
    @player.user_id ==  @game.judge_id

  end
end

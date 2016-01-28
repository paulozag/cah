class RoundsController < ApplicationController
  before_action :set_instance_variables_from_route, except: [:new]

  def new

    if player.user_id ==  params[:judge_id]

      render_correct_judge_launch
    else
      render :player_launch
    end
  end

  def draw_card
  end

  def  question_displayed
  end

  def select_winner
  end
  private

  def set_instance_variables_from_route
    @game = Game.find(params[:game_id])
    @player = Player.find(params[:player_id])
  end
end

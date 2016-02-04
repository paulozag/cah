class Player < ActiveRecord::Base
  belongs_to :user
  belongs_to :game
  has_many :question_cards
  has_many :answer_cards

  before_create :assign_initial_values

  private
  def assign_initial_values
    self.handle = User.find(self.user_id).handle
  end
end

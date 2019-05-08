# frozen_string_literal: true

class User < ApplicationRecord
  has_many :games, dependent: :destroy
  has_many :subscribers, dependent: :destroy
  has_many :lists
  has_many :pairs
  has_many :gamerlists
  has_many :pairlists

  def already_inside_another_users_gamerlist?(players_that_player1_that_has_already_played_with)
    players_that_player1_that_has_already_played_with.include? id
  end
end

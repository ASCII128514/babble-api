# frozen_string_literal: true

class Gamerlist < ApplicationRecord
  belongs_to :user
  belongs_to :pairlist

  # validates :unique_in_this_game

  # private

  # def unique_in_this_game
  #   if user.id
  # end
end

class Pairlist < ApplicationRecord
  belongs_to :user
  belongs_to :game
  has_many :gamerlists
end

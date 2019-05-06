# frozen_string_literal: true

class Gamerlist < ApplicationRecord
  belongs_to :user
  belongs_to :pairlist
  has_many :gamerlists
end

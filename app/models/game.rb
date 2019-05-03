# frozen_string_literal: true

class Game < ApplicationRecord
  belongs_to :user
  has_many :rounds, dependent: :destroy
  has_many :user, through: :subscribers
end

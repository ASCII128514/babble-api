# frozen_string_literal: true

class Game < ApplicationRecord
  belongs_to :user
  has_many :rounds, dependent: :destroy
  has_many :subscribers
  has_many :users, through: :subscribers
end

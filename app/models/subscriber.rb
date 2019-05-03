# frozen_string_literal: true

class Subscriber < ApplicationRecord
  belongs_to :game
  belongs_to :user
end

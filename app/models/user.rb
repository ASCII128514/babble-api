# frozen_string_literal: true

class User < ApplicationRecord
  has_many :games
  has_many :subscribers
end

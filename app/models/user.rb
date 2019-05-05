# frozen_string_literal: true

class User < ApplicationRecord
  has_many :games, dependent: :destroy
  has_many :subscribers, dependent: :destroy
  has_many :lists
  has_many :pairs
end

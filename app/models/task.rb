# frozen_string_literal: true

class Task < ApplicationRecord
  has_many :rounds, dependent: :destroy
  has_many :gamerlists
end

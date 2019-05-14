# frozen_string_literal: true

class AddQuestionToTask < ActiveRecord::Migration[5.2]
  def change
    add_reference :gamerlists, :task, foreign_key: true
  end
end

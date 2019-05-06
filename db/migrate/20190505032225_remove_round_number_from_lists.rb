# frozen_string_literal: true

class RemoveRoundNumberFromLists < ActiveRecord::Migration[5.2]
  def change
    remove_column :lists, :round_number
  end
end

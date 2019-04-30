# frozen_string_literal: true

class RenameRoundsToRoundNumber < ActiveRecord::Migration[5.2]
  def change
    rename_column :games, :rounds, :round_number
    # Ex:- rename_column("admin_users", "pasword","hashed_pasword")
  end
end

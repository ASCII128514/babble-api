# frozen_string_literal: true

class Games < ActiveRecord::Migration[5.2]
  def change
    add_column :games, :game_round_now, :integer, default: 0
    # Ex:- add_column("admin_users", "username", :string, :limit =>25, :after => "email")
  end
end

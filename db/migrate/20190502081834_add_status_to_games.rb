# frozen_string_literal: true

class AddStatusToGames < ActiveRecord::Migration[5.2]
  def change
    add_column :games, :status, :string
    # Ex:- add_column("admin_users", "username", :string, :limit =>25, :after => "email")
  end
end

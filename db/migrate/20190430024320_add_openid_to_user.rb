# frozen_string_literal: true

class AddOpenidToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :openid, :string
    # Ex:- add_column("admin_users", "username", :string, :limit =>25, :after => "email")
  end
end

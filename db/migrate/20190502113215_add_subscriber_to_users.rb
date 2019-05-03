# frozen_string_literal: true

class AddSubscriberToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :subscriber, :column_type, :column_options
    # Ex:- add_column("admin_users", "username", :string, :limit =>25, :after => "email")
  end
end

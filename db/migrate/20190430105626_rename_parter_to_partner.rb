# frozen_string_literal: true

class RenameParterToPartner < ActiveRecord::Migration[5.2]
  def change
    rename_column :games, :find_parter_timer, :find_partner_timer
    # Ex:- rename_column("admin_users", "pasword","hashed_pasword")
  end
end

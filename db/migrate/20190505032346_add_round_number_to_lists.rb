class AddRoundNumberToLists < ActiveRecord::Migration[5.2]
  def change
    add_column :lists, :round_number, :integer
  end
end

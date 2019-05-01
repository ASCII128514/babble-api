class CreateGames < ActiveRecord::Migration[5.2]
  def change
    create_table :games do |t|
      t.integer :rounds
      t.integer :find_parter_timer
      t.integer :selfie_timer
      t.integer :question_timer
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end

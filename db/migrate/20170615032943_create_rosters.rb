class CreateRosters < ActiveRecord::Migration[5.0]
  def change
    create_table :rosters do |t|
      t.string :roster_id
      t.boolean :won
      t.boolean :left
      t.integer :score
      t.integer :kraken
      t.integer :aces
      t.integer :turretsKilled
      t.integer :turretsRemaining
      t.float :gold
      t.belongs_to :match, index: true

      t.timestamps
    end
  end
end

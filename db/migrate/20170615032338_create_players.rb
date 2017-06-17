class CreatePlayers < ActiveRecord::Migration[5.0]
  def change
    create_table :players do |t|
      t.string :ign
      t.string :region
      t.integer :karma
      t.integer :level
      t.integer :played
      t.integer :skillTier
      t.integer :wins

      t.timestamps
    end
  end
end

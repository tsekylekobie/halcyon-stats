class CreateParticipants < ActiveRecord::Migration[5.0]
  def change
    create_table :participants do |t|
      t.string :hero
      t.string :skin
      t.integer :kills
      t.integer :deaths
      t.integer :assists
      t.float :farm
      t.integer :jungleKills
      t.integer :crystalMineCaptures
      t.integer :goldMineCaptures
      t.boolean :afk
      t.float :gold
      t.boolean :won
      t.string :participant_id
      t.belongs_to :roster, index: true
      t.belongs_to :player, index: true

      t.timestamps
    end
  end
end

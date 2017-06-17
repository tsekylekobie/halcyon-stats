class CreatePlayersAndMatches < ActiveRecord::Migration[5.0]
  def change
    create_table :matches_players do |t|
    	t.belongs_to :match, index: true
    	t.belongs_to :player, index: true
    end
  end
end

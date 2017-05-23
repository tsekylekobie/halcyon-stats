class CreatePlayers < ActiveRecord::Migration[5.0]
  def change
    create_table :players do |t|
    	t.string :ign
    	t.text :user_id

      t.timestamps
    end
  end
end

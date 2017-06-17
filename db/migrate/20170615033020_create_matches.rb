class CreateMatches < ActiveRecord::Migration[5.0]
  def change
    create_table :matches do |t|
      t.string :match_id
      t.string :date
      t.integer :duration
      t.string :gameMode
      t.string :region

      t.timestamps
    end
  end
end

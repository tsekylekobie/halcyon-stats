class AddReferences < ActiveRecord::Migration[5.0]
  def change
  	add_reference :players, :matches, index: true
  	add_reference :matches, :players, index: true
  end
end

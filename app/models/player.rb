class Player < ApplicationRecord
	has_and_belongs_to_many :matches
	has_many :participants
end

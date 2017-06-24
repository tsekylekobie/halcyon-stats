class Participant < ApplicationRecord
	belongs_to :player
	belongs_to :roster
	has_many :items
end

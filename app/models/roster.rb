class Roster < ApplicationRecord
	belongs_to :match
	has_many :participants, dependent: :destroy
end

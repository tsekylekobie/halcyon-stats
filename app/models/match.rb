class Match < ApplicationRecord
	has_many :rosters, dependent: :destroy
	has_and_belongs_to_many :players
end

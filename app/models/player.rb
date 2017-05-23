class Player < ApplicationRecord
	def to_param
		self.ign
	end
end

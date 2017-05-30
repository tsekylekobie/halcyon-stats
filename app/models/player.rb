class Player
	attr_reader :id, :ign, :region, :karmaLevel, :level, :played, :skillTier, :wins, :winPercent

	def initialize(id, lib)
		playerOS = lib.find { |p| p.type == 'player' && p.id == id }
		@id = playerOS.id
		@ign = playerOS.attributes.name
		@region = playerOS.attributes.shardId.upcase
		@karmaLevel = calculateKarma(playerOS.attributes.stats.karmaLevel)
		@level = playerOS.attributes.stats.level
		@played = playerOS.attributes.stats.played
		@skillTier = calculateSkillTier(playerOS.attributes.stats.skillTier)
		@wins = playerOS.attributes.stats.wins
		@winPercent = (100.0 * @wins / @played).round(2).to_s + '%'
	end

	def calculateKarma(k)
		if k == 0
			'Bad Karma'
		elsif k == 1
			'Good Karma'
		else
			'Great Karma'
		end
	end

	def calculateSkillTier(st)
		tiers = {0 => 'Just Beginning', 1 => 'Getting There', 2 => 'Rock Solid', 3 => 'Worthy Foe', 4 => 'Got Swagger', 5 => 'Credible Threat', 6 => 'The Hotness', 7 => 'Simply Amazing', 8 => 'Pinnacle of Awesome', 9 => 'Vainglorious'}
		divisions = {0 => 'Bronze', 1 => 'Silver', 2 => 'Gold'}
		
		"#{tiers[st / 3]} #{divisions[st % 3]}"
	end
end

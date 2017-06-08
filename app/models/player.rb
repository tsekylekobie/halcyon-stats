class Player
	attr_reader :id, :ign, :region, :karmaLevel, :level, :played, :skillTier, :wins, :winPercent
	include MatchesHelper

	def initialize(id, lib)
		playerOS = lib.find { |p| p.type == 'player' && p.id == id }
		@id = playerOS.id
		@ign = playerOS.attributes.name
		@region = playerOS.attributes.shardId.upcase
		stats = playerOS.attributes.stats
		@karmaLevel = calcKarma(stats.karmaLevel)
		@level = stats.level
		@played = stats.played
		if lib.length > 1
			participant = lib.find { |p| p.type == 'participant' && @id == p.relationships.player.data.id }
			@skillTier = calcSkillTier(participant.attributes.stats.skillTier)
		else
			@skillTier = calcSkillTier(stats.skillTier)
		end
		@wins = stats.wins
		@winPercent = calcWinPercentage(@wins, @played - @wins, 2)
	end

	def calcKarma(k)
		if k == 0
			'Bad Karma'
		elsif k == 1
			'Good Karma'
		else
			'Great Karma'
		end
	end

	def calcSkillTier(st)
		tiers = {0 => 'Just Beginning', 1 => 'Getting There', 2 => 'Rock Solid', 3 => 'Worthy Foe', 4 => 'Got Swagger', 5 => 'Credible Threat', 6 => 'The Hotness', 7 => 'Simply Amazing', 8 => 'Pinnacle of Awesome', 9 => 'Vainglorious'}
		divisions = {0 => 'Bronze', 1 => 'Silver', 2 => 'Gold'}
		
		"#{tiers[st / 3]} #{divisions[st % 3]}"
	end
end

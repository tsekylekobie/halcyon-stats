class Roster
	attr_reader :id, :region, :acesEarned, :gold, :heroKills, :krakenCaptures, :side, :turretKills, :turretsRemaining, :won, :participants

	def initialize(id, lib)
		rosterOS = lib.find { |r| r.type == 'roster' && r.id == id }
		@id = rosterOS.id
		stats = rosterOS.attributes.stats
		@acesEarned = stats.acesEarned
		@gold = stats.gold
		@heroKills = stats.heroKills
		@krakenCaptures = stats.krakenCaptures
		@side = stats.side
		@turretKills = stats.turretKills
		@turretsRemaining = stats.turretsRemaining
		@won = rosterOS.attributes.won == 'true'
		@participants = rosterOS.relationships.participants.data.map { |p| Participant.new(p.id, lib) }
	end
end

class Roster
	attr_reader :id, :region, :acesEarned, :gold, :heroKills, :krakenCaptures, :side, :turretKills, :turretsRemaining, :won, :participants

	def initialize(id, lib)
		rosterOS = lib.find { |r| r.type == 'roster' && r.id == id }
		@id = rosterOS.id
		@acesEarned = rosterOS.attributes.stats.acesEarned
		@gold = rosterOS.attributes.stats.gold
		@heroKills = rosterOS.attributes.stats.heroKills
		@krakenCaptures = rosterOS.attributes.stats.krakenCaptures
		@side = rosterOS.attributes.stats.side
		@turretKills = rosterOS.attributes.stats.turretKills
		@turretsRemaining = rosterOS.attributes.stats.turretsRemaining
		@won = rosterOS.attributes.won == 'true'
		@participants = rosterOS.relationships.participants.data.map { |p| Participant.new(p.id, lib) }
	end
end

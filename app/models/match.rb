class Match
	attr_reader :createdAt, :duration, :gameMode, :rosterA, :rosterB

	def initialize(data, lib) 
	# `data` is primary match data, `lib` is library of additional details about match
		@id = data.id
		@createdAt = data.attributes.createdAt
		@duration = "#{data.attributes.duration/60}m #{data.attributes.duration%60}s"
		@gameMode = data.attributes.gameMode
		@patchVersion = data.attributes.patchVersion
		@region = data.attributes.shardId
		@teams = data.relationships.rosters.data.map { |t| Roster.new(t.id, lib)}
	end
end

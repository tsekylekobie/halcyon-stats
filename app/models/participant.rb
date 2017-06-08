class Participant
	attr_reader :hero, :skinKey, :kills, :deaths, :assists, :items, :farm, :player

	@@names = JSON.parse(File.read('lib/assets/pretty.json'))

	def initialize(id, lib)

		participantOS = lib.find { |p| p.type == 'participant' && p.id == id }
		@hero = @@names[participantOS.attributes.actor]
		stats = participantOS.attributes.stats
		@skinKey = stats.skinKey
		@kills = stats.kills
		@deaths = stats.deaths
		@assists = stats.assists
		@items = stats.items.map { |i|
			if @@names.key?(i)
				@@names[i]
			else # If item not found in dictionary, return self
				i
			end
		}
		@farm = stats.farm
		id = participantOS.relationships.player.data.id
		@player = Player.new(id, lib)
	end
end

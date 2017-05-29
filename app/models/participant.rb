class Participant
	attr_reader :hero, :skinKey, :kills, :deaths, :assists, :items, :farm, :player

	@@names = JSON.parse(File.read('lib/assets/pretty.json'))

	def initialize(id, lib)

		participantOS = lib.find { |p| p.type == 'participant' && p.id == id }
		@hero = @@names[participantOS.attributes.actor]
		@skinKey = participantOS.attributes.stats.skinKey
		@kills = participantOS.attributes.stats.kills
		@deaths = participantOS.attributes.stats.deaths
		@assists = participantOS.attributes.stats.assists
		@items = participantOS.attributes.stats.items
		@farm = participantOS.attributes.stats.farm
		id = participantOS.relationships.player.data.id
		@player = Player.new(id, lib)
	end
end

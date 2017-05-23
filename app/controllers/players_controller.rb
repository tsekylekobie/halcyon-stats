require 'vainglory_api'

class PlayersController < ApplicationController
	@db;

	def show
		@db = VaingloryAPI.new($api_key, params[:shard_id])
		player = @db.players(params[:username])

		if !player.success? # If player not found
			redirect_to root_path(notFound: true)
		else
			player = player.data[0]
			@name = player.attributes.name
			@server = player.attributes.shardId.upcase!
			@level = player.attributes.stats.level
			@total_games = player.attributes.stats.played
			@win_percentage = (100.0 * player.attributes.stats.wins / @total_games).round(2)
			@karma_text = calculateKarma(player.attributes.stats.karmaLevel)
			@skill_tier = calculateSkillTier(player.attributes.stats.skillTier)
			@recent_matches = getRecentMatches(player.id)
		end
	end

	def getRecentMatches(id, numMatches = 5)
		@db.matches({"filter[playerIds]" => id, "page[limit]" => numMatches}).data
		# Matches controller? to parse match info, maybe use a partial to handle match html
	end

	def calculateKarma(k)
		if k == 0
			"Bad Karma"
		elsif k == 1
			"Good Karma"
		else
			"Great Karma"
		end
	end

	def calculateSkillTier(st)
		tiers = {0 => "Just Beginning", 1 => "Getting There", 2 => "Rock Solid", 3 => "Worthy Foe", 4 => "Got Swagger", 5 => "Credible Threat", 6 => "The Hotness", 7 => "Simply Amazing", 8 => "Pinnacle of Awesome", 9 => "Vainglorious"}
		divisions = {0 => "Bronze", 1 => "Silver", 2 => "Gold"}
		
		"#{tiers[st / 3]} #{divisions[st % 3]}"
	end
end

require 'vainglory_api'
require 'time'

class PlayersController < ApplicationController
	include MatchesHelper
	attr_reader :db

	def show
		@db = VaingloryAPI.new($api_key, params[:shard_id])
		player = @db.players(params[:username])

		if !player.success? # If player not found
			redirect_to root_path(notFound: true)
		else
			@player = Player.new(player.data[0].id, player.data)
			@recent_matches = getRecentMatches(@player.id)
		end
	end

	def getRecentMatches(id, offset = 0, numMatches = 5)
		tStart = Time.new(2017, 05).utc.iso8601
		puts tStart
		req = @db.matches({"filter[playerIds]" => id, "filter[createdAt-start]" => tStart, "page[offset]" => offset, "page[limit]" => numMatches, "sort" => "-createdAt"})
		jsonToMatchObject(JSON.parse(req.raw.body, object_class: OpenStruct))
	end
end

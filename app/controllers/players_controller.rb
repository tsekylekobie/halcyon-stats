require 'vainglory_api'
require 'time'

class PlayersController < ApplicationController
	include MatchesHelper
	
	attr_reader :db
	$names = JSON.parse(File.read('lib/assets/pretty.json'))

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

	def getRecentMatches(id)
		tStart = Time.new(2017, 01).utc.iso8601
		req = @db.matches({"filter[playerIds]" => id, "filter[createdAt-start]" => tStart, "sort" => "-createdAt"})
		jsonToMatchObject(JSON.parse(req.raw.body, object_class: OpenStruct))
	end
end

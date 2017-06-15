require 'vainglory_api'
require 'time'

class PlayersController < ApplicationController
	include MatchesHelper
	
	attr_reader :client
	$names = JSON.parse(File.read('lib/assets/pretty.json'))

	def show
		@client = VaingloryAPI.new($api_key, params[:shard_id])
		player = @client.players(params[:username])

		if !player.success? # If player not found
			redirect_to root_path(notFound: true)
		else
			@player = Player.new(player.data[0].id, player.data)
			@recent_matches = collectMatches("ranked", @player.id)
			@stats = collectPlayerStats(@player.ign, @recent_matches)
		end
	end
end

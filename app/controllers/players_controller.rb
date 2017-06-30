require 'vainglory_api'

class PlayersController < ApplicationController
	$NAMES = JSON.parse(File.read('lib/assets/pretty.json'))

  	def index
    	@players = Player.all
  	end

  	def create
  		@client = VaingloryAPI.new($api_key, params[:shard_id])
  		
  		# Find requested player
  		response = @client.players(params[:username])
  		if !response.success?
  			redirect_to root_path(notFound: true)
  			return
  		end
  		response = response.data[0].attributes
  		if !Player.exists?(ign: response.name)
  			user = Player.new
  			user.ign = response.name
  			user.region = response.shardId
  			user.karma = response.stats.karmaLevel
  			user.level = response.stats.level
  			user.played = response.stats.played
  			user.skillTier = response.stats.skillTier
  			user.wins = response.stats.wins
  			user.save!
  		else
  			user = Player.find_by_ign(response.name)
  		end

  		# Find recent matches
		response = @client.matches({"filter[playerNames]" => user.ign,
									"filter[gameMode]" => "ranked",
									"page[limit]" => 10,
									"sort" => "-createdAt"})
		response.data.each { |m|
			if !Match.exists?(match_id: m.id)
				match = Match.new(match_id: m.id)
				match.createdTimestamp = m.attributes.createdAt
				match.duration = m.attributes.duration
				match.gameMode = m.attributes.gameMode
				match.region = m.attributes.shardId
	
				user.matches << match
	
				# Create Rosters
				m.relationships.rosters.data.each { |r|
					roster = Roster.new(roster_id: r.id)
					rStruct = response.included.select {|x| x.type.eql? "roster" and x.id.eql? r.id}[0]
					roster.won = rStruct.attributes.won
					roster.left = rStruct.attributes.stats.side.eql? "left/blue"
					roster.score = rStruct.attributes.stats.heroKills # Score differs per game mode
					roster.kraken = rStruct.attributes.stats.krakenCaptures
					roster.aces = rStruct.attributes.stats.acesEarned
					roster.turretsKilled = rStruct.attributes.stats.turretKills
					roster.turretsRemaining = rStruct.attributes.stats.turretsRemaining
					roster.gold = rStruct.attributes.stats.gold
	
					match.rosters << roster
	
					# Create Participants
					rStruct.relationships.participants.data.each { |p|
						participant = Participant.new(participant_id: p.id)
						pStruct = response.included.select {|x| x.type.eql? "participant" and x.id.eql? p.id}[0]
						participant.hero = $NAMES[pStruct.attributes.actor]
						participant.skin = pStruct.attributes.stats.skinKey
						participant.kills = pStruct.attributes.stats.kills
						participant.deaths = pStruct.attributes.stats.deaths
						participant.assists = pStruct.attributes.stats.assists
						participant.farm = pStruct.attributes.stats.farm
						participant.jungleKills = pStruct.attributes.stats.jungleKills
						participant.crystalMineCaptures = pStruct.attributes.stats.crystalMineCaptures
						participant.goldMineCaptures = pStruct.attributes.stats.goldMineCaptures
						participant.afk = pStruct.attributes.stats.wentAfk
						participant.gold = pStruct.attributes.stats.gold
						participant.won = pStruct.attributes.stats.winner
						# Create Items
						pStruct.attributes.stats.items.each { |i|
							item = Item.new
							$NAMES.key?(i) ? item.name = $NAMES[i] : item.name = i
							participant.items << item
						}
	
						roster.participants << participant
	
						# Create Players
						pStruct = response.included.select {|x| x.type.eql? "player" and x.id.eql? pStruct.relationships.player.data.id}[0]
						if !Player.exists?(ign: pStruct.attributes.name)
							player = Player.new
							player.ign = pStruct.attributes.name
							player.region = pStruct.attributes.shardId
							player.karma = pStruct.attributes.stats.karmaLevel
							player.level = pStruct.attributes.stats.level
							player.played = pStruct.attributes.stats.played
							player.skillTier = pStruct.attributes.stats.skillTier
							player.wins = pStruct.attributes.stats.wins
							player.save!
						else
							player = Player.find_by_ign(pStruct.attributes.name)
						end

						player.participants << participant
					}
				}
			end
		}

  		# URL should be localhost:3000/region/ign
  		redirect_to player_path(ign: user.ign)
  	end

	def show
		@player = Player.find_by_ign(params[:ign])
		@matches = @player.matches
		@stats = collectPlayerStats(@player.ign, @matches)
	end

	private
		def collectPlayerStats(playerIGN, matches)
			heroesPlayed = Hash.new {|hash,key| hash[key]={wins: 0, losses: 0}}
			sideRecord = Hash.new {|hash,key| hash[key]={wins: 0, losses: 0}}
			aceTotal = 0.0
			krakenTotal = 0.0
			kills, assists, deaths = 0.0, 0.0, 0.0
	
			# LEFT WINS
			# Some Active Record call

			matches.each { |m| 
				m.rosters.each { |r| 
					r.participants.each { |p|
						if p.player.ign.eql? playerIGN
							aceTotal += r.aces
							krakenTotal += r.kraken
							kills += p.kills
							assists += p.assists
							deaths += p.deaths
							if r.won
								r.left ? sideRecord["left"][:wins] += 1 : sideRecord["right"][:wins] += 1
								heroesPlayed[p.hero][:wins] += 1
							else
								r.left ? sideRecord["left"][:losses] += 1 : sideRecord["right"][:losses] += 1
								heroesPlayed[p.hero][:losses] += 1
							end
						end
					}
				}
			}

			return {:kills => kills, :assists => assists, :deaths => deaths,
					:heroesPlayed => heroesPlayed.sort_by {|k,v| v[:wins] + v[:losses]}.reverse,
					:averageAce => aceTotal / matches.length,
					:averageKraken => krakenTotal / matches.length,
					:sideRecord => sideRecord}
		end

		### HELPER METHODS FOR VIEWS ###

		def calcWinPercentage(wins, losses, digits=0)
			"#{(100.0 * wins / (wins + losses)).round(digits)}%"
		end
		helper_method :calcWinPercentage

		def convertSecondsToMinutes(seconds)
			Time.at(seconds).utc.strftime("%M:%S")
		end
		helper_method :convertSecondsToMinutes
end

module MatchesHelper
	def collectPlayerStats(playerIGN, matches) # `matches` is collection of Match objects, generated by jsonToMatchObject()
		heroesPlayed = Hash.new {|hash,key| hash[key]={wins: 0, losses: 0}}
		sideRecord = Hash.new {|hash,key| hash[key]={wins: 0, losses: 0}}
		aceTotal = 0.0
		krakenTotal = 0.0
		kills, assists, deaths = 0.0, 0.0, 0.0

		matches.each { |m| 
			m.rosters.each { |r| 
				puts r.inspect
				r.participants.each { |p|
					puts p.inspect
					if p.player.ign.eql? playerIGN
						aceTotal += t.acesEarned
						krakenTotal += t.krakenCaptures
						kills += p.kills
						assists += p.assists
						deaths += p.deaths
						if t.won
							sideRecord[t.side][:wins] += 1
							heroesPlayed[p.hero][:wins] += 1
						else
							sideRecord[t.side][:losses] += 1
							heroesPlayed[p.hero][:losses] += 1
						end
					end
				}
			}
		}

		return {:kills => kills, :assists => assists, :deaths => deaths, :heroesPlayed => heroesPlayed.sort_by {|k,v| v[:wins] + v[:losses]}.reverse, :averageAce => aceTotal / matches.length, :averageKraken => krakenTotal / matches.length, :sideRecord => sideRecord}
	end

	def calcWinPercentage(wins, losses, digits=0)
		"#{(100.0 * wins / (wins + losses)).round(digits)}%"
	end
end
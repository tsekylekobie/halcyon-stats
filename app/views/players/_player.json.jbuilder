json.extract! player, :id, :ign, :region, :karma, :level, :played, :skillTier, :wins, :created_at, :updated_at
json.url player_url(player, format: :json)

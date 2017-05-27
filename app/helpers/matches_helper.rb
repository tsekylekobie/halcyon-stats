module MatchesHelper
	def jsonToMatchObject(os) # `m` is data pulled in OpenStruct format 
		# Organize OpenStruct into array of similar objects
		os.data.map { |m| Match.new(m, os.included) }
	end
end
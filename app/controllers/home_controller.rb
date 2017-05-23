class HomeController < ApplicationController
	def index
		# There should be a better/logical way to display error message
		@notFound = params[:notFound]
	end
end

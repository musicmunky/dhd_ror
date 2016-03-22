class PagesController < ApplicationController

	def index
#		render :layout => "comics"
		if params[:id]
			#puts "\n\n\n\n\n\n\n\n\n\nID IS: #{params[:id]}\n\n\n\n\n\n\n\n\n\n"
		end
	end

	def archive
	end

	def about
	end

	def contact
	end

	def store
	end

end

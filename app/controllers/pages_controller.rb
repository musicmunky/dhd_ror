class PagesController < ApplicationController

	def index
		@comic = {}
		if params[:id]
			@id = params[:id].gsub('?p=', '')
			@comic = Post.find(@id)
		elsif params[:p]
			@id = params[:p].gsub('?p=', '')
#			logger.debug "\n\n\n\n\n\n\nID IS: #{@id}\n\n\n\n\n\n\n"
			@comic = Post.find(@id)
		else
			@comic = Post.get_latest
		end
	end

	def dhdadmin
		render :layout => "admin"
	end

	def users
		@users = User.all
		render :layout => "admin"
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

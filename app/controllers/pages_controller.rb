class PagesController < ApplicationController
	before_action :authenticate_user!, :except => [:index, :archive, :about, :contact, :store]

	def index
		@comic = {}
		@meta  = {}
		begin
			if params[:id]
				@id = params[:id].gsub('?p=', '')
				@comic = Post.find(@id)
			elsif params[:p]
				@id = params[:p].gsub('?p=', '')
#				logger.debug "\n\n\n\n\n\n\nID IS: #{@id}\n\n\n\n\n\n\n"
				@comic = Post.find(@id)
			else
				@comic = Post.get_latest
			end
		rescue
			@comic = Post.new
			@comic.id = 0
			@comic.title = "Move along..."
			@comic.content = "Without precise calculations we could fly right through a popup or bounce too close to a supernova, and that'd end your trip real quick, wouldn't it?"
		end
		if @comic.id > 0
			@meta = @comic.get_post_meta
		else
			@meta['comic_file'] = "obiwan.jpg"
			@meta['comic_description'] = "Hokey religions and ancient weapons are no match for a good webcomic in your browser..."
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

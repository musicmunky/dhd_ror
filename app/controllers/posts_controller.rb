class PostsController < ApplicationController
	before_action :set_post, only: [:show, :edit, :update, :destroy]
	before_action :authenticate_user! #, :except => [:show, :index]

	layout "admin"

	# GET /posts
	# GET /posts.json
	def index
		@posts = Post.all
	end

	# GET /posts/1
	# GET /posts/1.json
	def show
	end

	# GET /posts/new
	def new
		@post = Post.new
	end

	# GET /posts/1/edit
	def edit
	end

	# POST /posts
	# POST /posts.json
	def create
# 		@post = Post.new(post_params)
		err = 0
		ntc = ""
		logger.debug "\n\n\n\n\n\n\n\nFILE IS: #{post_params[:file]}\n\n\n\n\n\n\n\n\n\n\n"
		begin
			uploader = ComicUploader.new
			uploader.store!(post_params[:file])
			f = post_params[:file]
#  			logger.debug "FILENAME: #{f.original_filename}"
			dir = "/var/www/dhd_ror/TEMPIMGDIR/images/"
			logger.debug("Attempting to rename '#{dir}#{f.original_filename}' to '#{dir}#{post_params[:file_name]}'")
			File.rename("#{dir}#{f.original_filename}", "#{dir}#{post_params[:file_name]}")
		rescue => error
#			logger.debug "\n\n\n\n\n\n\nPOST IS: #{post_params.to_s}\n\n\n\n\n\n\n"
			ntc = "There was an error uploading the file: #{error.message}"
			err = 1
		ensure
			if err == 1
				@post = Post.new
				respond_to do |format|
					format.html { render :new, alert: ntc }
				end
			else
				respond_to do |format|
					format.html { redirect_to new_post_url, notice: 'Post was successfully created!' }
				end
			end
		end
=begin
		respond_to do |format|
			if @post.save
				format.html { redirect_to @post, notice: 'Post was successfully created.' }
				format.json { render :show, status: :created, location: @post }
			else
				format.html { render :new }
				format.json { render json: @post.errors, status: :unprocessable_entity }
			end
		end
=end
	end

	# PATCH/PUT /posts/1
	# PATCH/PUT /posts/1.json
	def update
		respond_to do |format|
			if @post.update(post_params)
				format.html { redirect_to @post, notice: 'Post was successfully updated.' }
				format.json { render :show, status: :ok, location: @post }
			else
				format.html { render :edit }
				format.json { render json: @post.errors, status: :unprocessable_entity }
			end
		end
	end

	# DELETE /posts/1
	# DELETE /posts/1.json
	def destroy
		@post.destroy
		respond_to do |format|
			format.html { redirect_to posts_url, notice: 'Post was successfully destroyed.' }
			format.json { head :no_content }
		end
	end

	private
	# Use callbacks to share common setup or constraints between actions.
	def set_post
		@post = Post.find(params[:id])
	end

	# Never trust parameters from the scary internet, only allow the white list through.
	def post_params
		params.require(:post).permit(:user_id, :file, :file_name, :title, :content, :name, :alttext, :status, :live_date, :guid, :live_time)
	end
end

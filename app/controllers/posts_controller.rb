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

	# POST /posts/1/checkFileExists
	def checkFileExists
		upl = params[:newfile]
		fln = params[:filenam]

		response = {}
		content  = {}
		status   = ""
		message  = ""

		begin
			dir = Rails.application.config.comic_dir

			if File.exists?("#{dir}#{upl}") || File.exists?("#{dir}#{fln}")
				raise "File already exists!"
			end

			response['status'] = "success"
			response['message'] = "File does not exist!"
			response['content'] = content

		rescue => error
			response['status'] = "failure"
			response['message'] = "Error: #{error.message}"
			response['content'] = error.backtrace
		ensure
			respond_to do |format|
				format.html { render :json => response.to_json }
			end
		end
	end


	# POST /posts
	# POST /posts.json
	def create
		err = 0
		ntc = ""
		begin

			fname1 = post_params[:file].original_filename
			fname2 = post_params[:file_name]

			uploader = PostUploader.new
			uploader.store!(post_params[:file])

			dir = Rails.application.config.comic_dir
			logger.debug("Attempting to rename '#{dir}#{fname1}' to '#{dir}#{fname2}'")

			File.rename("#{dir}#{fname1}", "#{dir}#{fname2}")
			File.chmod(0775, "#{dir}#{fname2}")

			@post = Post.new
			@post.user_id = post_params[:user_id]
			@post.title = post_params[:title]
			@post.status = post_params[:status] == "active" ? "publish" : "pending"
			@post.content = post_params[:content]
			@post.name = post_params[:title].downcase.gsub(/[^0-9a-z ]/i, '').split(" ").join("-")
			@post.live_date = DateTime.strptime("#{post_params[:live_date]} #{post_params[:live_time]} #{Time.now.getlocal.zone}", '%m/%d/%Y %H:%M:%S %Z')

			@post.save!

			@post.update_attribute(:guid, "#{root_url}#{@post.id}")
			@post.update_attribute(:create_date_gmt, @post.created_at)
			@post.update_attribute(:update_date_gmt, @post.updated_at)

			@com_desc = PostMetum.new({meta_key: "comic_description", value: post_params[:alttext], post_id: @post.id})
			@com_file = PostMetum.new({meta_key: "comic_file", value: fname2, post_id: @post.id})

			@com_desc.save!
			@com_file.save!

		rescue => error
			ntc = "There was an error uploading the file: #{error.message}"
			err = 1
		ensure
			if err == 1
				@post = Post.new
				respond_to do |format|
					format.html { redirect_to new_post_url, alert: ntc }
				end
			else
				respond_to do |format|
					format.html { redirect_to new_post_url, notice: "Post '#{post_params[:title]}'was successfully created!" }
					format.json { render :show, status: :created, location: @post }
				end
			end
		end
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

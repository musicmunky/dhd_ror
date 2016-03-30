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


	def updateUserInfo

		uid = params[:user_id]
		adm = params[:user_req_update]
		dat = params[:field_data]

		response = {}
		content  = {}
		status   = ""
		message  = ""
# 		logger.debug "\n\n\n\n\n\n\nID IS: #{uid}\n\n\n\n\n\n\n"

		begin
			@admn = User.find(adm)
			if !@admn.has_role? :admin
				msg = "INSUFFICIENT PRIVILEGES ERROR"
				logger.debug "\n\n#{msg}\n\n"
				raise msg
			end

			@user = User.find(uid)

			dat.each do |key, value|
				@user.update_attribute(key.to_sym, value)
			end

			response['status'] = "success"
			response['message'] = "Updated user information for #{@user.get_name}"
			response['content'] = content
		rescue => error
			response['status'] = "failure"
			response['message'] = "Error: #{error.message}"
			response['content'] = "User with insufficient privileges attempted to update attributes of another user"
# 			response['content'] = error.backtrace
		ensure
			respond_to do |format|
				format.html { render :json => response.to_json }
			end
		end

	end


	def disableUser

		uid = params[:user_id]
		dis = params[:is_disabled]

		response = {}
		content  = {}
		status   = ""
		message  = ""

		begin
			@user = User.find(uid)

			arch = (dis == "true") ? true : false
			@user.update({archive: arch})

			content['user'] = @user.attributes

			response['status'] = "success"
			response['message'] = "Updated account information for #{@user.get_name}"
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


	def resetPassword
		uid = params[:user_id]

		response = {}
		content  = {}
		status   = ""
		message  = ""

		begin
			@user = User.find(uid)

 			@pass = Devise.friendly_token.first(10)
 			@user.password = @pass
 			@user.password_confirmation = @pass
 			if @user.save
 				PasswordResetMailer.password_reset_email(@user, @pass).deliver_now
 			end

			response['status'] = "success"
			response['message'] = "Password reset for #{@user.get_name}"
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


	def archive
	end

	def about
	end

	def contact
	end

	def store
	end

end

class Post < ActiveRecord::Base
	belongs_to :user
	has_many :post_metum

	def self.get_first
		Post.where("name != '' and status = 'publish'").order(created_at: :asc).first
	end


	def self.get_latest
		Post.where("name != '' and status = 'publish'").order(created_at: :desc).first
	end


	def self.get_next(id)
		@id = id
		@conn = ActiveRecord::Base.connection
		@result = @conn.exec_query("SELECT id FROM posts WHERE name != '' and status='publish'
						  			and created_at > (SELECT created_at FROM posts
									   		WHERE id=#{@id}) ORDER BY created_at ASC LIMIT 1;")
		@post = {}
		if @result.length > 0
			@r = @result.first
			@post = Post.find(@r['id'])
		else
			@post = Post.get_latest
		end
		return @post
	end


	def self.get_previous(id)
		@id = id
		@conn = ActiveRecord::Base.connection
		@result = @conn.exec_query("SELECT id FROM posts WHERE name != '' and status='publish'
						  			and created_at < (SELECT created_at FROM posts
									   		WHERE id=#{@id}) ORDER BY created_at DESC LIMIT 1;")
		@post = {}
		if @result.length > 0
			@r = @result.first
			@post = Post.find(@r['id'])
		else
			@post = Post.get_latest
		end
		return @post
	end


	def self.get_random
		Post.limit(1).order("RAND()")
	end

	def get_post_meta

=begin
	Problem IDs:
	51,65,70,84,91,108,117,123,129,148,156,163,167,171,174,180,183,
	186,204,212,215,231,235,240,244,249,252,255,269,278,307,407
=end

		comicmeta = {}
		@metakeys = PostMetum.uniq.pluck(:meta_key)
		@metakeys.each do |mk|
			comicmeta[mk] = ""
		end

		@postmeta = self.post_metum
		if @postmeta.length > 0
			@postmeta.each do |pm|
				comicmeta[pm.meta_key] = pm.value
			end
		end

		if comicmeta['comic_description'].nil? or comicmeta['comic_description'].blank?
			comicmeta['comic_description'] = self.title
		end

		return comicmeta
	end

end

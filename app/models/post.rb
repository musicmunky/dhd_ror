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
		Post.limit(1).order("RAND()").first
	end


	def self.get_post_years
		@conn = ActiveRecord::Base.connection
		@result = @conn.exec_query("SELECT DISTINCT LEFT(created_at, 4) AS yr FROM posts ORDER BY yr DESC;")
		@years = []
		if @result.length > 0
			@result.each do |r|
				@years.push(r['yr'])
			end
		end
		return @years
	end


	def self.get_comics_by_year(y)
		@year = y
		@conn = ActiveRecord::Base.connection
		@comics = []
		@result = @conn.exec_query("SELECT id, created_at, title, guid FROM posts
									WHERE created_at like '#{@year}%'
										AND name != '' ORDER BY created_at DESC;")
		if @result.length > 0
			@result.each do |r|
				@comics.push(r)
			end
		end
		return @comics
	end


	def get_post_meta

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

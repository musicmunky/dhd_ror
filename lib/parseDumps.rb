#!/home/tandrews/.rvm/rubies/ruby-2.2.1/bin/ruby
##!/usr/local/bin/ruby

require 'optparse'
require 'mysql2'
require 'sequel'
require 'json'


def parseAnnouncements(json)
=begin
            :id => :integer,
       :content => :text,
       :user_id => :integer,
        :active => :boolean,
    :created_at => :datetime,
    :updated_at => :datetime
=end
=begin
{
	"ID"=>1,
	"announcement"=>"Hey people!  <a href=\"https://forekast.com/\">Forekast</a> just launched!<a href=\"http://blog.forekast.com/\">blog post.</a>",
	"active"=>0
}
=end
#	puts "\n\nJSON: #{json[0]}\n\n"
	json.each do |hash|
		MYSQL[:announcements].insert(
			'id' => hash['ID'],
			'content' => hash['announcement'],
			'user_id' => 7,
			'active' => 0,
			"created_at" => Time.now.strftime("%Y-%m-%d %H:%M:%S"),
			"updated_at" => Time.now.strftime("%Y-%m-%d %H:%M:%S")
		)
	end

end


def parseMeta(json)
=begin
            :id => :integer,
       :post_id => :integer,
      :meta_key => :string,
         :value => :text,
    :created_at => :datetime,
    :updated_at => :datetime
=end
=begin
{
	"meta_id"=>8571,
	"post_id"=>3277,
	"meta_key"=>"comic_file",
	"meta_value"=>"2011-12-05-0147b86.png"
}
=end
#	puts "\n\nJSON: #{json[0]}\n\n"
	json.each do |hash|
		MYSQL[:post_meta].insert(
			'id' => hash['meta_id'],
			'post_id' => hash['post_id'],
			'meta_key' => hash['meta_key'],
			'value' => hash['meta_value'],
			"created_at" => Time.now.strftime("%Y-%m-%d %H:%M:%S"),
			"updated_at" => Time.now.strftime("%Y-%m-%d %H:%M:%S")
		)

	end

end


def parsePosts(json)
=begin
                 :id => :integer,
            :user_id => :integer,
    :create_date_gmt => :datetime,
    :update_date_gmt => :datetime,
              :title => :text,
            :content => :text,
               :name => :string,
             :status => :string,
          :live_date => :datetime,
               :guid => :text,
         :created_at => :datetime,
         :updated_at => :datetime
=end
=begin
{
	 "ID"=>56,
	 "post_author"=>5,
	 "post_date"=>"2009-01-15 13:31:18",
	 "post_date_gmt"=>"2009-01-15 18:31:18",
	 "post_content"=>"Q: Why are your comics so funny?...",
	 "post_title"=>"FAQ",
	 "post_status"=>"publish",
	 "post_name"=>"faq",
	 "post_modified"=>"2012-05-09 16:38:33",
	 "post_modified_gmt"=>"2012-05-09 21:38:33",
	 "post_parent"=>0,
	 "guid"=>"http://www.thedoghousediaries.com/?page_id=56",
	 "post_type"=>"page",
	 "post_live_date"=>"0000-00-00 00:00:00"
}
=end
	#puts "\n\nJSON: #{json[0]}\n\n"
	json.each do |hash|
		MYSQL[:posts].insert(
			'id' => hash['ID'],
			'user_id' => hash['post_author'],
			"create_date_gmt" => hash['post_date_gmt'],
			"update_date_gmt" => hash['post_modified_gmt'],
			'title' => hash['post_title'],
			'content' => hash['post_content'],
			'name' => hash['post_name'],
			'status' => hash['post_status'],
			'live_date' => hash['post_live_date'],
			'guid' => hash['guid'],
			"created_at" => hash['post_date'],
			"updated_at" => hash['post_modified']
		)
	end

end


options = {}
OptionParser.new do |opts|
	opts.banner = "Usage: ruby control_parser.rb [options]"

	opts.on("-h", "--help", "Script options:") do
		puts opts
		exit
	end

	opts.on("-u username", "--user username", String, "Set database user (REQUIRED)") do |u|
		options[:username] = u
	end

	opts.on("-p password", "--password password", String, "Set database password (REQUIRED)") do |p|
		options[:password] = p
	end

	opts.on("-o host", "--host hostname", String, "Database hostname (defaults to 'localhost')") do |h|
		options[:hostname] = h
	end

	opts.on("-d database", "--database database", String, "Set the database for the parser (defaults to 'dhd_ror_development')") do |d|
		options[:database] = d
	end

end.parse!

dbhost = options[:hostname] ? options[:hostname] : "localhost"
dbname = options[:database] ? options[:database] : "dhd_ror_development"
dbuser = options[:username] ? options[:username] : ""
dbpass = options[:password] ? options[:password] : ""

if dbuser == "" or dbpass == ""
	puts "Please enter the username and password for your database!\n\n"
	exit(0)
end

begin

	MYSQL = Sequel.connect(:adapter => 'mysql2', :host => dbhost, :database => dbname, :username => dbuser, :password => dbpass, :test => true)

	puts "Beginning JSON parsing now..."

#	annc		= File.read('../dbexports/dhdannouncements.json')
#	annc_hash	= JSON.parse(annc)
#	parseAnnouncements(annc_hash)

#	post		= File.read('../dbexports/posts.json')
#	post_hash	= JSON.parse(post)
#	parsePosts(post_hash)

#	meta		= File.read('../dbexports/postmeta.json')
#	meta_hash	= JSON.parse(meta)
#	parseMeta(meta_hash)

	puts "Completed JSON parsing - please verify database is correct\n"

	exit(0)

rescue => error
	puts "ERROR PROCESSING: #{error.message}\n\nFULL ERROR:\n#{error.backtrace}"
end

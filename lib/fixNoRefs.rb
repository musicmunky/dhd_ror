#!/home/tandrews/.rvm/rubies/ruby-2.2.1/bin/ruby

require 'mysql2'
require 'sequel'


MYSQL = Sequel.connect(:adapter => 'mysql2', :host => "localhost", :database => "dhd_ror_development", :username => "", :password => "!", :test => true)

file_array = []

problem_array = [[51, "2009-01-15"],[65, "2009-01-20"],[70, "2009-01-22"],[84, "2009-01-26"],[91, "2009-01-28"],
[108, "2009-01-30"],[117, "2009-02-02"],[123, "2009-02-06"],[129, "2009-02-09"],[148, "2009-02-11"],
[156, "2009-02-13"],[163, "2009-02-16"],[235, "2009-03-18"],[240, "2009-03-20"],[244, "2009-03-23"],
[249, "2009-03-25"],[252, "2009-03-27"],[167, "2009-02-18"],[171, "2009-02-20"],[174, "2009-02-23"],
[180, "2009-02-25"],[183, "2009-02-27"],[186, "2009-03-02"],[204, "2009-03-06"],[212, "2009-03-11"],
[215, "2009-03-13"],[231, "2009-03-15"],[255, "2009-03-30"],[269, "2009-03-31"],[278, "2009-04-06"],
[307, "2009-04-10"],[407, "2009-05-04"]]

problem_array.each do |parr|
	lscmd = `ls -A1 ../app/assets/images/dhdcomics | grep #{parr[1]}`
	lsstr = lscmd.strip

	MYSQL[:post_meta].insert(
		'post_id' => parr[0],
		'meta_key' => "comic_file",
		'value' => lsstr,
		"created_at" => Time.now.strftime("%Y-%m-%d %H:%M:%S"),
		"updated_at" => Time.now.strftime("%Y-%m-%d %H:%M:%S")
	)

	puts "INSERTED: #{lsstr} FOR COMIC ID: #{parr[0]}"
end


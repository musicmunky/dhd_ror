#!/home/tandrews/.rvm/rubies/ruby-2.2.1/bin/ruby

require 'mysql2'
require 'sequel'


MYSQL = Sequel.connect(:adapter => 'mysql2', :host => "localhost", :database => "dhd_ror_development", :username => "", :password => "", :test => true)

=begin
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
=end

problem_array = [[196,'Always forget something','2009-03-04-57695733095b3a370fc05ce5a7e95e0c.png'],
[302,'Strategy','2009-04-08-433fddd4d4118d0e16456cac6db7eb70.jpg'],[312,'Throwback','2009-04-13-7a5deb7e50c69ad960c6be23e4316890.png'],
[327,'Pitter','2009-04-15-343d763b1ff26a07a92831ce4979c55f.png'],[334,'The Photoshop Argument','2009-04-17-4143097bc2d0451f4da05e4a536488d1.png'],
[341,'Scammers','2009-04-20-f2f67bc860d506b85f772317a25f0a61.png'],[355,'Buyer\'s Remorse','2009-04-22-947b499d6d2879fa3554a5d93c85d92e.png'],
[376,'Worlds Scariest Computer Virus','2009-04-27-e5781552b76d7f133ba93930ea620efe.jpg'],[396,'SpeedomEATer','2009-05-01-70f4c7beb18c7966e423fc2de51fa99c.png'],
[424,'Sound Dating Advice','2009-05-06-a9733bec68316bb9d4f8d6beb145392c.png'],[448,'That\'s Deep','2009-05-11-0f7c4f933c53bc00ad8a6bc54d242a6e.png'],
[461,'Doghouse Times Issue 2','2009-05-15-4fe6409a5e0c854a76111953bb114eca.png'],[475,'WolframAlpha','2009-05-20-60aca0e6f4bf707d37b97fa2e7dab2b8.png'],
[482,'Horror Movies','2009-05-22-36ec9b663fd81d9366811d0b873b62eb.png'],[485,'Two Truths and A Lie','2009-05-25-ae246b3dde6885efd793d41644880611.png'],
[497,'Negativity Sheep','2009-05-27-61d75a82085333a7490a65883138d28f.png'],[499,'Darth Dad-er','2009-05-29-37caf514550bad35243a93debed0c6f9.png'],
[506,'Girls At A Pool','2009-06-01-a89e0f0cdb35103f58765fe9c126fb88.png'],[507,'Girlology: Lesson 1','2009-06-03-3f68bd3bfab28ffd087276ba81fc9636.png'],
[514,'The Versatility of Dude','2009-06-05-e38e6cf824a0fac7718d7d99a804fbb7.png'],[528,'Wild Pizza','2009-06-08-24a5c782c355a067c1fe2c749e0774f8.png']]

problem_array.each do |parr|

	MYSQL[:post_meta].insert(
		'post_id' => parr[0],
		'meta_key' => "comic_file",
		'value' => parr[2],
		"created_at" => Time.now.strftime("%Y-%m-%d %H:%M:%S"),
		"updated_at" => Time.now.strftime("%Y-%m-%d %H:%M:%S")
	)

	puts "INSERTED: #{parr[2]} FOR COMIC ID: #{parr[0]}"
end


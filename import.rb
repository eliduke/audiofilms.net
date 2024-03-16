require 'themoviedb'
require 'slugify'
require 'open-uri'
require 'bunny_cdn'
require 'dotenv/load'
require 'pry'

# To use this utility, first you need to get an API Key from
# themoviedb.org. It's free and super duper ding dang simple.
# Copy and paste your key down below and save the file (please
# DO NOT commit your API key to the repo). When you are ready,
# go to the root directory of this repo and run these command:
#
# $ ruby import.rb 12345
# $ ruby import.rb 12345 34567
#
# You can run the script with one or many ids, and those are
# found on a single movie page at themoviedb.org. The domain
# looks something like this:
#
# https://www.themoviedb.org/movie/8193-napoleon-dynamite
#
# The id for Napolean Dynamite is right there: 8193. So I copy
# that and then paste it in with the script up above. The script
# then automatically creates the necessary file with the output.
#
# napoleon-dynamite.md

Tmdb::Api.key(ENV['TMDB_API_KEY'])

BunnyCdn.configure do |config|
  config.apiKey = ENV['BUNNY_API_KEY']
  config.storageZone = "audiofilms"
  config.region = "la"
  config.accessKey = ENV['BUNNY_ACCESS_KEY']
end

input_ids = ARGV

if input_ids.empty?
  puts "You must provide at least one movie id (from themoviedb.org), like this:\n\n"
  puts "$ ruby tmdb.rb 81933\n\n"
  puts "Or you can provide multiple ids at once, like this:\n\n"
  puts "$ ruby tmdb.rb 666 665 664\n\n"
  return
end

input_ids.each do |id|
  movie = Tmdb::Movie.detail(id)

  # RETURN if movie can't be found
  if movie['success'] == false
    puts "The resource you requested could not be found."
    return
  end

  title = movie['original_title']
  slug = title.slugify

  # RETURN because the episode has already been imported!
  if File.exist?("_films/#{slug}.md")
    puts "#{title} has already been imported."
    return
  end

  puts "IMPORTING - #{title}..."

  puts "* Uploading image file..."
  URI.open("https://image.tmdb.org/t/p/original/#{movie['poster_path']}") do |image|
    path = "#{slug}.jpg"
    File.open(path, "wb") { |file| file.write(image.read) }
    if BunnyCdn::Storage.uploadFile('images', path)
      File.delete(path)
    end
  end

  puts "* Creating film file..."
  File.open("_films/#{slug}.md", "w") do |f|
    f.write(
    <<~EOS
    ---
    tmdb-id: #{movie['id']}
    layout: film
    added: #{Date.today.strftime("%F")}
    released: #{movie['release_date']}
    title: #{title}
    permalink: #{slug}
    description: >
      #{movie['overview']}
    ---
    EOS
    )
  end

  puts "SUCCESS!!"
end

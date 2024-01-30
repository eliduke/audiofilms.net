require 'themoviedb'
require 'slugify'

# To use this utility, first you need to get an API_KEY from
# themoviedb.org. Input that below, save the file, but please
# DO NOT commit your API key to the repo. When you are ready,
# go to the root directory of this repo and run these command:
#
# $ ruby tmdb.org 12345
# $ ruby tmdb.org 12345 34567
#
# You can run the script with one or many ids, and those are
# found on a single movie page at themoviedb.org. The domain
# looks something like this:
#
# https://www.themoviedb.org/movie/8193-napoleon-dynamite
#
# The id for Napolean Dynamite is right there: 8193. So I copy
# that and then paste it in with the script up above. The output
# from the script is the full content of one of the film files.
# Just copy and paste that into a slugified file name like:
#
# napoleon-dynamite.md

Tmdb::Api.key("API_KEY")

input_ids = ARGV

if input_ids.empty?
  puts "You must provide at least one movie id, like this:"
  puts ""
  puts "$ ruby tmdb.rb 81933"
  puts ""
  puts "Or you can provide multiple ids at once, like this:"
  puts ""
  puts "$ ruby tmdb.rb 666 665 664"
  return
end

input_ids.each do |id|
  movie = Tmdb::Movie.detail(id)

  if movie['success'] == false
    puts "The resource you requested could not be found."
    return
  end

  puts "---"
  puts "tmdb-id: #{movie['id']}"
  puts "layout: film"
  puts "added: #{Date.today.strftime("%Y-%m-%d")}"
  puts "released: #{movie['release_date']}"
  puts "title: #{movie['original_title']}"
  puts "permalink: #{movie['original_title'].slugify}"
  puts "description: #{movie['overview']}"
  puts "---"
  puts ""
end

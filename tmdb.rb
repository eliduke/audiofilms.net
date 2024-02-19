require 'themoviedb'
require 'slugify'

# To use this utility, first you need to get an API Key from
# themoviedb.org. It's free and super duper ding dang simple.
# Copy and paste your key down below and save the file (please
# DO NOT commit your API key to the repo). When you are ready,
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
# that and then paste it in with the script up above. The script
# then automatically creates the necessary file with the output.
#
# napoleon-dynamite.md
#
###############################################################
your_api_key = "API_KEY"
###############################################################

if your_api_key == "API_KEY"
  puts "You gotta add your API Key to tmdb.rb, ya dummy."
  return
end

Tmdb::Api.key(your_api_key)

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

  if movie['success'] == false
    puts "The resource you requested could not be found."
    return
  end

  slug = movie['original_title'].slugify

  File.open("_films/#{slug}.md", "w") do |f|
    f.write(
    <<~EOS
    ---
    tmdb-id: #{movie['id']}
    layout: film
    added: #{Date.today.strftime("%Y-%m-%d")}
    released: #{movie['release_date']}
    title: #{movie['original_title']}
    permalink: #{slug}
    description: #{movie['overview']}
    ---
    EOS
    )
  end
end

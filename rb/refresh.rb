require 'themoviedb'
require 'open-uri'
require 'dotenv/load'
require 'pry'

require_relative 'sluggit'

Tmdb::Api.key(ENV['TMDB_API_KEY'])

puts "Refreshing _film files..."
Dir['_films/*'].each do |film_file_path|
  film_file = File.open(film_file_path)
  film_yaml = YAML.load(film_file.read, permitted_classes: [Date])

  # This is for Peter and the Wolf
  next if film_yaml['tmdb-id'].nil?

  movie = Tmdb::Movie.detail(film_yaml['tmdb-id'])
  title = movie['original_title']
  slug  = sluggit(title, movie['release_date'])

  puts "* #{movie['original_title']}"
  File.open("_films/#{slug}.md", "w") do |f|
    f.write(
    <<~EOS
    ---
    tmdb-id: #{movie['id']}
    layout: film
    added: #{film_yaml['added']}
    released: #{movie['release_date']}
    slug: #{slug}
    title: >
      #{title}
    description: >
      #{movie['overview']}
    ---
    EOS
    )
  end
end

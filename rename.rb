require 'themoviedb'
require 'slugify'
require 'open-uri'
require 'bunny_cdn'
require 'dotenv/load'
require 'pry'

def sluggit(title, release_date)
  year = Date.parse(release_date).strftime('%Y')

  adjusted_title = if title.start_with?('The ')
    title.gsub('The ', '')
  elsif title.start_with?('A ')
    title.gsub('A ', '')
  else
    title
  end

  "#{adjusted_title.slugify}-#{year}"
end

Tmdb::Api.key(ENV['TMDB_API_KEY'])

puts "Creating _film files..."
Dir['_films/*'].each do |film_file_path|
  film_file  = File.open(film_file_path)
  film_yaml  = YAML.load(film_file.read, permitted_classes: [Date])

  # This is for Peter and the Wolf
  next if film_yaml['tmdb-id'].nil?

  tmdb_movie = Tmdb::Movie.detail(film_yaml['tmdb-id'])

  title = tmdb_movie['original_title']
  slug  = sluggit(title, tmdb_movie['release_date'])

  puts "* #{tmdb_movie['original_title']}"
  File.open("_films/#{slug}.md", "w") do |f|
    f.write(
    <<~EOS
    ---
    tmdb-id: #{tmdb_movie['id']}
    layout: film
    added: #{film_yaml['added']}
    released: #{tmdb_movie['release_date']}
    slug: #{slug}
    permalink: films/#{slug}
    title: >
      #{title}
    description: >
      #{tmdb_movie['overview']}
    ---
    EOS
    )
  end
end

require 'slugify'

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

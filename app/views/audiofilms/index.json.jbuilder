json.array!(@audiofilms) do |audiofilm|
  json.extract! audiofilm, :id, :title, :description, :release, :slug
  json.url audiofilm_url(audiofilm, format: :json)
end

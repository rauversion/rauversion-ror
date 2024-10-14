SitemapGenerator::Sitemap.default_host = "http://#{ENV['DOMAIN']}"
SitemapGenerator::Sitemap.create do
  add '/welcome'

  Track.published.find_each do |c|
    add track_path(c)
  end

  User.artists.find_each do |c|
    add user_path(c.username)
  end

  Playlist.published.find_each do |c|
    add playlist_path(c)
  end

  Post.published.find_each do |c|
    add article_path(c)
  end
end
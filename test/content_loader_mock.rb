require File.join(File.dirname(__FILE__), '..', 'lib', 'content_loader')

class PlaylistsLoaderMock < ContentLoader
  def download_content(url)
    File.read(File.join(File.dirname(__FILE__), 'playlists'))
  end
end

class PlaylistLoaderMock < ContentLoader
  def download_content(url)
    File.read(File.join(File.dirname(__FILE__), 'playlist'))
  end
end

class PlaylistVideoLoaderMock < ContentLoader
  def download_content(url)
    File.read(File.join(File.dirname(__FILE__), 'playlist_video'))
  end
end

class FavoritesLoaderMock < ContentLoader
  def download_content(url)
    File.read(File.join(File.dirname(__FILE__), 'favorites'))
  end
end

class FavoriteVideoLoaderMock < ContentLoader
  def download_content(url)
    File.read(File.join(File.dirname(__FILE__), 'favorite_video'))
  end
end






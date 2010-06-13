require File.join(File.dirname(__FILE__), '..', 'lib', 'content_loader')

class PlaylistLoaderMock < ContentLoader
  def download_content(url)
    File.read(File.join(File.dirname(__FILE__), 'playlists'))
  end
end




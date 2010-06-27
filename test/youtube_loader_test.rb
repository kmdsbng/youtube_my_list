require File.join(File.dirname(__FILE__), 'helper')
require 'youtube_loader'
require 'content_loader_mock'

class YoutubeLoaderTest < Test::Unit::TestCase
  must 'load playlists' do
    correct_entry_element_size = 9
    assert_equal(correct_entry_element_size, YoutubeLoader.new(PlaylistsLoaderMock.new).load_playlists('').size)
  end

  must 'load playlist' do
    correct_entry_element_size = 20
    video_list = YoutubeLoader.new(PlaylistLoaderMock.new).load_playlist('')
    assert_equal(correct_entry_element_size, video_list.entries.size)
    assert_equal("FCDC71DC5FAD06B5", video_list.playlist_id)
  end

  must 'load favorites' do
    correct_entry_element_size = 24
    video_list = load_favorites
    assert_equal(correct_entry_element_size, video_list.entries.size)
  end

  must 'load playlist video' do
    video = YoutubeLoader.new(PlaylistVideoLoaderMock.new).load_playlist_video('FCDC71DC5FAD06B5', 3)
    assert(!video.href.to_s.empty?)
    assert_equal(84, video.duration.to_i)
  end

  def load_favorites
    YoutubeLoader.new(FavoritesLoaderMock.new).load_favorites('')
  end

  must 'load favorite video' do
    video = YoutubeLoader.new(FavoriteVideoLoaderMock.new).load_favorite_video('tami0519', 3)
    assert(!video.href.to_s.empty?)
    assert_equal(128, video.duration.to_i)
  end

  must 'get favorite url' do
    expected = "http://gdata.youtube.com/feeds/api/users/hogemoge/favorites"
    assert_equal(expected, YoutubeLoader.new.get_favorite_url('hogemoge'))
  end
end



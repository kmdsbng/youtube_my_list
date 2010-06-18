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
    assert_equal(correct_entry_element_size, YoutubeLoader.new(PlaylistLoaderMock.new).load_playlist('').entries.size)
  end

  must 'load favorites' do
    correct_entry_element_size = 24
    video_list = load_favorites
    assert_equal(correct_entry_element_size, video_list.entries.size)
  end

  def load_favorites
    YoutubeLoader.new(FavoritesLoaderMock.new).load_favorites('')
  end
end



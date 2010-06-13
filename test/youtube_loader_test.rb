require File.join(File.dirname(__FILE__), 'helper')
require 'youtube_loader'
require 'content_loader_mock'

class YoutubeLoaderTest < Test::Unit::TestCase
  must 'load entries' do
    correct_entry_element_size = 9
    assert_equal(correct_entry_element_size, YoutubeLoader.new(PlaylistLoaderMock.new).load_playlists('').size)
  end
end



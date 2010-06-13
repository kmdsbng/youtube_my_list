require 'content_loader'
require 'cgi'

Entry = Struct.new(:title, :href, :content, :updated, :playlist_id)

class YoutubeLoader
  def initialize(content_loader=ContentLoader.new)
    @content_loader = content_loader
  end

  def load_playlists(account)
    url = "http://gdata.youtube.com/feeds/api/users/#{CGI.escapeHTML(account)}/playlists"
    data = @content_loader.load_xml(url)
    entry_nodes = data.xpath(%{//xmlns:entry})
    convert_to_entry(entry_nodes)
  end

  def convert_to_entry(nodes)
    nodes.map {|n|
      Entry.new(n.xpath('./xmlns:title')[0].text,
                n.xpath('./gd:feedLink')[0].attributes['href'].text,
                n.xpath('./xmlns:content[@type="text"]')[0].text,
                Time.parse(n.xpath('./xmlns:updated')[0].text),
                n.xpath('./yt:playlistId')[0].text
      )
    }
  end

  def load_playlist(account)
    url = "http://gdata.youtube.com/feeds/api/users/#{CGI.escapeHTML(account)}/playlists"
    data = @content_loader.load_xml(url)
    entry_nodes = data.xpath(%{//xmlns:entry})
    convert_to_entry(entry_nodes)
  end

end



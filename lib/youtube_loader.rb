require 'content_loader'
require 'cgi'

Entry = Struct.new(:title, :href, :content, :updated, :playlist_id)
PlaylistEntry = Struct.new(:title, :href, :content, :updated)

class YoutubeLoader
  def initialize(content_loader=ContentLoader.new)
    @content_loader = content_loader
  end

  def load_playlists(account)
    url = "http://gdata.youtube.com/feeds/api/users/#{CGI.escapeHTML(account)}/playlists"
    data = @content_loader.load_xml(url)
    entry_nodes = data.xpath(%{//xmlns:entry})
    convert_to_playlists_entry(entry_nodes)
  end

  def convert_to_playlists_entry(nodes)
    nodes.map {|n|
      content = n.xpath('./xmlns:content[@type="text"]')[0]
      Entry.new(n.xpath('./xmlns:title')[0].text,
                n.xpath('./gd:feedLink')[0].attributes['href'].text,
                content ? content : nil,
                Time.parse(n.xpath('./xmlns:updated')[0].text),
                n.xpath('./yt:playlistId')[0].text
      )
    }
  end

  def load_playlist(account)
    url = "http://gdata.youtube.com/feeds/api/playlists/#{CGI.escapeHTML(account)}"
    doc = @content_loader.load_xml(url)
    entry_nodes = doc.xpath(%{//xmlns:entry})
    convert_to_playlist_entry(doc, entry_nodes)
  end

  def convert_to_playlist_entry(doc, nodes)
    nodes.map {|n|
      content = n.xpath('./xmlns:content[@type="text"]')[0]
      media_content = n.xpath('./media:group/media:content[@yt:format="5"]', doc.root.namespaces)[0]
      PlaylistEntry.new(n.xpath('./xmlns:title')[0].text,
                media_content ? media_content.attributes['url'] : nil,
                content ? content : nil,
                Time.parse(n.xpath('./xmlns:updated')[0].text)
      )
    }
  end

end



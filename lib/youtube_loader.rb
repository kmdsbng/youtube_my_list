require 'content_loader'
require 'cgi'

Entry = Struct.new(:title, :href, :content, :updated, :playlist_id)
VideoEntry = Struct.new(:title, :href, :content, :updated, :thumbnail)
VideoListData = Struct.new(:entries, :prev_url, :next_url)

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

  def load_playlist(playlist_id)
    url = "http://gdata.youtube.com/feeds/api/playlists/#{CGI.escapeHTML(playlist_id)}"
    doc = @content_loader.load_xml(url)
    entry_nodes = doc.xpath(%{//xmlns:entry})
    title = doc.xpath(%{/xmlns:feed/xmlns:title})[0].text
    [title, convert_to_video_entry(doc, entry_nodes)]
  end

  def convert_to_video_entry(doc, nodes)
    nodes.map {|n|
      content = n.xpath('./xmlns:content[@type="text"]')[0]
      media_content = n.xpath('./media:group/media:content[@yt:format="5"]', doc.root.namespaces)[0]
      thumbnail = n.xpath('./media:group/media:thumbnail')[0]
      VideoEntry.new(n.xpath('./xmlns:title')[0].text,
                media_content ? media_content.attributes['url'].text : nil,
                content ? content : nil,
                Time.parse(n.xpath('./xmlns:updated')[0].text),
                thumbnail ? thumbnail.attributes['url'].text : nil
      )
    }
  end

  def load_favorites(account)
    url = "http://gdata.youtube.com/feeds/api/users/#{CGI.escapeHTML(account)}/favorites"
    load_favorites_sub(url)
  end

  def load_favorites_sub(url)
    puts url
    doc = @content_loader.load_xml(url)
    entry_nodes = doc.xpath(%{//xmlns:entry})
    videos = convert_to_video_entry(doc, entry_nodes)
    next_url = get_next_url(doc)
    prev_url = get_prev_url(doc)
    videos
  end

  def get_next_url(doc)
    rel = doc.xpath(%{//xmlns:link[@rel="next"]})
    rel.empty? ? nil : rel[0].attributes['href'].text
  end

  def get_prev_url(doc)
    rel = doc.xpath(%{//xmlns:link[@rel="prev"]})
    rel.empty? ? nil : rel[0].attributes['href'].text
  end

end



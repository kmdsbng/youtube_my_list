require 'content_loader'
require 'cgi'

Entry = Struct.new(:title, :href, :content, :updated, :playlist_id)
VideoEntry = Struct.new(:title, :href, :content, :updated, :thumbnail)
VideoListData = Struct.new(:entries, :prev_url, :next_url, :title, :author, :account)
PlaylistVideo = Struct.new(:href, :total)

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
                n.xpath('./gd:feedLink')[0].attributes['href'].text, content ? content : nil,
                Time.parse(n.xpath('./xmlns:updated')[0].text),
                n.xpath('./yt:playlistId')[0].text
      )
    }
  end

  def load_playlist(playlist_id)
    url = "http://gdata.youtube.com/feeds/api/playlists/#{CGI.escapeHTML(playlist_id)}"
    load_playlist_by_url(url)
  end

  def load_playlist_by_url(url)
    doc = @content_loader.load_xml(url)
    entry_nodes = doc.xpath(%{//xmlns:entry})
    title = get_title(doc)
    videos = convert_to_video_entry(doc, entry_nodes)
    create_video_list(doc, videos)
  end

  def load_playlist_video(playlist_id, position)
    url = "http://gdata.youtube.com/feeds/api/playlists/#{CGI.escapeHTML(playlist_id)}?start-index=#{position}&max-results=1"
    doc = @content_loader.load_xml(url)
    entry_nodes = doc.xpath(%{//xmlns:entry})
    title = get_title(doc)
    videos = convert_to_video_entry(doc, entry_nodes)
    result = PlaylistVideo.new
    result.href = videos.empty? ? nil : videos[0].href
    total_node = doc.xpath(%{/xmlns:feed/openSearch:totalResults})
    result.total = total_node ? total_node.text.to_i : 0
    result
  end

  def create_video_list(doc, videos)
    next_url = get_next_url(doc)
    prev_url = get_prev_url(doc)
    title = get_title(doc)
    author = get_author(doc)
    VideoListData.new(videos, prev_url, next_url, title, author)
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
    load_favorites_by_url(url)
  end

  def load_favorites_by_url(url)
    doc = @content_loader.load_xml(url)
    entry_nodes = doc.xpath(%{//xmlns:entry})
    videos = convert_to_video_entry(doc, entry_nodes)
    create_video_list(doc, videos)
  end

  def get_title(doc)
    title = doc.xpath(%{/xmlns:feed/xmlns:title})
    title.empty? ? nil : title[0].text
  end

  def get_next_url(doc)
    rel = doc.xpath(%{//xmlns:link[@rel="next"]})
    rel.empty? ? nil : rel[0].attributes['href'].text
  end

  def get_prev_url(doc)
    rel = doc.xpath(%{//xmlns:link[@rel="previous"]})
    rel.empty? ? nil : rel[0].attributes['href'].text
  end

  def get_author(doc)
    author = doc.xpath(%{/xmlns:feed/xmlns:author/xmlns:name})
    author.empty? ? nil : author[0].text
  end
end



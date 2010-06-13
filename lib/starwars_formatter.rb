$KCODE = 'u'

require 'pp'

class StarwarsFormatter
  ZENKAKU_SPACE = '　'
  HANKAKU_SPACE = ' '

  def initialize(text)
    @text = text
  end

  def format(init_col=7)
    chars = normalize_text(@text).split(//)
    lines = slice_lines(init_col, chars)
    indent_lines(lines).join("\n")
  end

  def normalize_text(text)
    text.gsub(/\s/, '').gsub(/　/,'')
  end

  def slice_lines(col, chars)
    lines = []
    while (!chars.empty?)
      next_line, remain = slice_line(chars, col)
      lines << next_line
      chars = remain
      col += 1
    end
    lines
  end

  def slice_line(chars, col)
    bytes = 0
    goal_byte = col * 2 - 1
    next_line = []
    while (bytes < goal_byte && !chars.empty?)
      l = chars.shift
      next_line << l
      bytes += multi_byte?(l) ? 2 : 1
    end
    [next_line.join, chars]
  end

  def multi_byte?(l)
    bytes = []
    l.each_byte{|d| bytes << d}
    bytes[0] >= 0x80
  end

  def indent_lines(lines)
    size = lines.size
    result = []
    lines.each_with_index {|s,i|
      result << indent(s, size - i)
    }
    result
  end

  def indent(str, indent_size)
    return (ZENKAKU_SPACE * (indent_size / 2)) + ((indent_size % 2 == 0) ? '' : HANKAKU_SPACE) + str
  end

end

def main
  str = StarwarsFormatter.new(load_text).format
  puts str
end

def load_text
  File.read(ARGV[0])
end

if $0 == __FILE__
  main
end


Dir.glob(File.dirname(__FILE__) + '/*.rb') {|f|
  next if (File.expand_path(f) == File.expand_path(__FILE__))
  require f
}





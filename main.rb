require 'pry'
require 'fileutils'
require 'nokogiri'
require 'fastimage'

unless ARGV[0].nil?
  src = ARGV[0].chomp
  src_prefix = ARGV[1] ? ARGV[1].chomp : "https:"

  dest = %(dest/#{File.basename(src)})
  doc = Nokogiri::HTML(File.open(src))

  tags = doc.search("img").map { |tag|
    key = tag.attributes["src"].value
    uri = src_prefix + key
    width, height = FastImage.size(uri)
    { search_word: %(src="#{key}"), replace_str: %(src="#{key}" width="#{width}" height="#{height}") }
  }

  content = File.read(src)
  tags.uniq.each { content.gsub!(_1[:search_word], _1[:replace_str]) }

  File.open(dest, "w") { _1.write content }
else
  puts "ERROR: File not specified."
  exit 1
end

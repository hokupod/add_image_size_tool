require 'pry'
require 'fileutils'
require 'nokogiri'
require 'fastimage'

unless ARGV[0].nil?
  src = ARGV[0].chomp
  src_prefix = ARGV[1] ? ARGV[1].chomp : ""

  dest = %(dest/#{File.basename(src)})
  html_src = Nokogiri::HTML.fragment(File.open(src).read)

  tags = html_src.search("img").map { |tag|
    next if tag["width"] && tag["height"]

    key = tag.attributes["src"].value
    uri = src_prefix + key
    width, height = FastImage.size(uri)

    replace_strs = %W(src="#{key}")
    replace_strs << %(width="#{width}") if tag["width"].nil?
    replace_strs << %(height="#{height}") if tag["height"].nil?
    { search_word: %(src="#{key}"), replace_str: replace_strs.join(" ") }
  }

  content = File.read(src)
  tags.uniq.compact.each { content.gsub!(_1[:search_word], _1[:replace_str]) }

  File.open(dest, "w") { _1.write content }
else
  puts "ERROR: File not specified."
  exit 1
end

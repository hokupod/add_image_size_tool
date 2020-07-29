require 'pry'
require 'fileutils'
require 'nokogiri'
require 'fastimage'

src = ARGV[0].chomp
dest = %(dest/#{File.basename(src)})
doc = Nokogiri::HTML(File.open(src))

tags = doc.search("img").map { |tag|
    key = tag.attributes["src"].value
    uri = "https:#{key}"
    width, height = FastImage.size(uri)
    { search_word: %(src="#{key}"), replace_str: %(src="#{key}" width="#{width}" height="#{height}") }
}

content = File.read(src)
tags.uniq.each { content.gsub!(_1[:search_word], _1[:replace_str]) }

File.open(dest, "w") { _1.write content }

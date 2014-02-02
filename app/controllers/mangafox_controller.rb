class MangafoxController < ApplicationController
  require 'open-uri'
  # search manga by name
  def search
  end

  # list chapters of a specific manga
  def manga
  end

  # list pages of a specific chapter
  def chapter
    link = params[:link]
    chapter_link = link[0..link.rindex("/")]
    # request link
    doc = Nokogiri.parse open(link)
    # get page number
    total_page = doc.at_xpath("//select[@class='m']/option[last()-1]/@value")
    @image_links = []
    (1..total_page.value.to_i).each do |page_number|
      page = Nokogiri.parse open(chapter_link + page_number.to_s + ".html")
      node = page.at_xpath("//img[@id='image']/@src")
      @image_links.push node.value if node.present?
    end
  end
end

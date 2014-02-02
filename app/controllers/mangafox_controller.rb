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
    # get image link of page 2 and 3
    page2 = Nokogiri.parse open(chapter_link + "2.html")
    total_page = page2.at_xpath("//select[@class='m']/option[last()-1]/@value").value
    previous_page = page2.at_xpath("//div[@id='chnav']/p[1]/a/@href")
    next_page = page2.at_xpath("//div[@id='chnav']/p[2]/a/@href")
    @previous_page_link = previous_page.value if previous_page.present?
    @next_page_link = next_page.value if next_page.present?
    image2 = page2.at_xpath("//img[@id='image']/@src").value
    page3 = Nokogiri.parse open(chapter_link + "3.html")
    image3 = page3.at_xpath("//img[@id='image']/@src").value
    # compare
    start_pos = str_diff image2, image3
    width = get_width(image2, start_pos)
    first_part = image2[0..(start_pos - width)]
    second_part = image2[(start_pos + 1)..-1]
    @image_links = []
    (1..total_page.to_i).each do |page_number|
      @image_links.push(first_part + sprintf("%0#{width}d", page_number) + second_part)
    end
  end
  
  private
  def str_diff s1, s2, init_pos=0
    i = init_pos
    while i < s1.length
      break if s1[i] != s2[i]
      i+=1
    end
    return i
  end

  def get_width s, start_pos
    i = start_pos - 1
    while i > 0
      break if s[i] != '0'
      i-=1
    end
    return start_pos - i
  end
end

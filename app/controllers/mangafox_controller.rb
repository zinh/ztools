class MangafoxController < ApplicationController
  require 'open-uri'
  # search manga by name
  def search
  end

  #search ajax
  def search_ajax
    uri = URI.parse "http://mangafox.me/ajax/search.php"
    search_param = {term: params[:query]}
    uri.query = URI.encode_www_form( search_param )
    result = uri.open.read
    render json: result
  end

  # list chapters of a specific manga
  def manga
    link = params[:link]
    doc = Nokogiri.parse open(link)
    chapter_nodes = doc.xpath("//a[@class='tips']") || []
    @chapters = []
    chapter_nodes.each do |chapter_node|
      title_node = chapter_node.at_xpath("./following-sibling::span[@class='title nowrap']/text()")
      title = title_node.text if title_node.present?
      @chapters.push({title: title, link: chapter_node.attributes['href'].value, link_id: chapter_node.text})
    end
  end

  # list pages of a specific chapter
  def chapter1
    link = params[:link]
    chapter_link = link[0..link.rindex("/")]
    # get image link of page 2 and 3
    page2 = Nokogiri.parse open(chapter_link + "4.html")
    total_page = page2.at_xpath("//select[@class='m']/option[last()-1]/@value").value
    total_page = total_page.to_i
    previous_page = page2.at_xpath("//div[@id='chnav']/p[1]/a/@href")
    next_page = page2.at_xpath("//div[@id='chnav']/p[2]/a/@href")
    @previous_page_link = previous_page.value if previous_page.present?
    @next_page_link = next_page.value if next_page.present?
    image2 = page2.at_xpath("//img[@id='image']/@src").value
    page3 = Nokogiri.parse open(chapter_link + "5.html")
    image3 = page3.at_xpath("//img[@id='image']/@src").value
    # compare
    start_pos = str_diff image2, image3
    number_pos = get_full_number image2, start_pos
    start_number = image2[number_pos..start_pos]
    width = get_width(image2, number_pos) + start_number.length - 1
    start_number = start_number.to_i
    first_part = image2[0..(start_pos - width)]
    second_part = image2[(start_pos + 1)..-1]
    # remove number after start pos
    pos = second_part.index /\D/
    second_part = second_part[pos..-1]
    @image_links = []
    (0..(total_page - 1)).each do |page_number|
      @image_links.push(first_part + sprintf("%0#{width}d", start_number + page_number) + second_part)
    end
  end

  def chapter
    link = params[:link]
    chapter_link = link[0..link.rindex("/")]
    # request link
    doc = Nokogiri.parse open(link)
    previous_page = doc.at_xpath("//div[@id='chnav']/p[1]/a/@href")
    next_page = doc.at_xpath("//div[@id='chnav']/p[2]/a/@href")
    @previous_page_link = previous_page.value if previous_page.present?
    @next_page_link = next_page.value if next_page.present?
    # get page number
    total_page = doc.at_xpath("//select[@class='m']/option[last()-1]/@value")
    @image_links = []
    (1..total_page.value.to_i).each do |page_number|
      page = Nokogiri.parse open(chapter_link + page_number.to_s + ".html")
      node = page.at_xpath("//img[@id='image']/@src")
      @image_links.push node.value if node.present?
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

  def get_full_number s, start_pos
    i = start_pos - 1
    while i > 0
      break if s[i] =~ /[0\D]/
        i-=1
    end
    return i + 1
  end
end

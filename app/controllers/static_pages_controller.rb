class StaticPagesController < ApplicationController

  def index
    crawler = PageCrawler.new
    @data = {}
    PageCrawler::SUPPORTED_SITES.each_key {|key| @data[key] = crawler.crawl_site(key) }
  end
  
end

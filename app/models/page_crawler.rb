class PageCrawler

  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend ActiveModel::Naming  

  attr_reader :data

  @mechanize = nil

  SUPPORTED_SITES = { :bloomberg => 'http://www.bloomberg.com/', :bbc_news => 'http://www.bbc.com/news',  :straits_times => 'http://www.straitstimes.com/'}
  
  def initialize
    @mechanize = Mechanize.new
  end

  def crawl_site(site)
    case site
    when :bloomberg
      @data = bloomberg_data(SUPPORTED_SITES[:bloomberg])
    when :bbc_news
      @data = bbc_news_data(SUPPORTED_SITES[:bbc_news])  
    when :straits_times
      @data = straits_times_data(SUPPORTED_SITES[:straits_times])        
    else    
      @data = nil
    end    

    return @data
  end

  private

  def bloomberg_data(url)
    page = @mechanize.get(url)
    article_data = []
    raw_articles = page.search('.hero-v6-story:not(.ad-after):not(.ad-before)')
    raw_articles += page.search('.highlights-v6-story:not(.ad-before):not(.ad-after)')
    raw_articles.each do |raw_article|
      article = NewsArticle.new
      article.headline = raw_article.search('div[class*="story__headline"]').text
      article.link = raw_article.search('a').attribute('href').value
      article.description = ''
      article_data << article
    end
    
    return article_data
  end

  def bbc_news_data(url)
    page = @mechanize.get(url)
    article_data = []
    raw_articles = page.search(".buzzard-item")
    raw_articles += page.search(".pigeon-item")
    raw_articles.each do |raw_article| 
      article = NewsArticle.new
      article.headline =raw_article.search('.title-link__title-text').text
      article.link = 'http://www.bbc.com' + raw_article.search('.title-link').attribute('href').value
      article.description = raw_article.search('div[class*="summary"]').text
      article_data << article
    end

    return article_data
  end

  def straits_times_data(url)
    page = @mechanize.get(url)
    article_data = []
    raw_articles = page.search("[data-vr-zone^='Top Stories']").search("div[class^='views-row']")    
    raw_articles.each do |raw_article|       
      article = NewsArticle.new
      article.headline = raw_article.search(".story-headline a").text
      article.link = url + raw_article.search(".story-headline a").attribute('href').value
      article.description = raw_article.search(".media-text").text
      article_data << article
    end    

    return article_data
  end  

  def cnn_news_data(url)
    page = @mechanize.get(url)
    article_data = []
    raw_articles = page.search(".cd_headline")
    raw_articles.each do |raw_article| 
      article = NewsArticle.new 
      article.headline = raw_article.search('span class*="cd_headline-text"').text 
      article.link = url + raw_article.search('a').attribute('href').value
      article_data << article
    end
    return article_data
  end


end





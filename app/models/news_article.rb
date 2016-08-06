class NewsArticle

  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend ActiveModel::Naming
    
  attr_accessor :headline, :link, :description
  def intialize
    @headline = ''
    @link = ''
    @description = ''
  end
end

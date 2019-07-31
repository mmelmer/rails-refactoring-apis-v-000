class GithubRepo

  attr_accessor :name, :url

  def initialize(init_hash)
   @name = init_hash['name']
   @url = init_hash['html_url']
  end

end
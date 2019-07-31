class GithubService

  attr_accessor :access_token



  def initialize(hash=nil)
    if hash
      @access_token = hash["access_token"]
    end
  end

   def authenticate!(client_id, client_secret, code)
    response = Faraday.post "https://github.com/login/oauth/access_token",
        {client_id: client_id, client_secret: client_secret, code: code},
        {'Accept' => 'application/json'}
    response_hash = JSON.parse(response.body)
    @access_token = response_hash["access_token"]
  end

  # def logged_in?
  #   !!session[:token]
  # end

  def get_username
    response = Faraday.get  "https://api.github.com/user", 
      {}, 
      {'Authorization' => "token #{self.access_token}", 'Accept' => 'application/json'}
    response_hash = JSON.parse(response.body)
    response_hash["login"]
  end

  def get_repos
    response = Faraday.get "https://api.github.com/user/repos", {}, 
      {'Authorization' => "token #{self.access_token}", 'Accept' => 'application/json'}
    response_hash = JSON.parse(response.body)
    response_hash.map{|repo| GithubRepo.new(repo)}
  end

  def create_repo (name)
    Faraday.post "https://api.github.com/user/repos", {name: name}.to_json, {'Authorization' => "token #{self.access_token}", 'Accept' => 'application/json'}

  end

end
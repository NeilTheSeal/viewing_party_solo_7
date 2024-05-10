class MovieService
  def self.top_rated
    conn = Faraday.new(url: "https://api.themoviedb.org") do |faraday|
      faraday.headers["Authorization"] =
        Rails.application.credentials.moviedb[:access_token]
      faraday.headers["accept"] = "application/json"
      faraday.params["include_adult"] = "false"
      faraday.params["include_video"] = "false"
      faraday.params["language"] = "en-US"
      faraday.params["page"] = "1"
      faraday.params["sort_by"] = "popularity.desc"
    end

    response = conn.get("/3/discover/movie")

    JSON.parse(response.body, symbolize_names: true)
  end

  def self.search(title)
    conn = Faraday.new(url: "https://api.themoviedb.org") do |faraday|
      faraday.headers["Authorization"] =
        Rails.application.credentials.moviedb[:access_token]
      faraday.headers["accept"] = "application/json"
      faraday.params["query"] = title
    end

    response = conn.get("/3/search/movie")

    JSON.parse(response.body, symbolize_names: true)
  end
end

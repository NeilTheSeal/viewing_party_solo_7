class MovieFacade
  attr_reader :movies

  def initialize(params)
    @params = params
    top_rated = params[:top_rated] == "true"

    @movies = if top_rated
                top_rated_movies
              else
                movie_search
              end
  end

  private

  def top_rated_movies
    json = MovieService.top_rated
    movie_array(json)
  end

  def movie_search
    json = MovieService.search(@params[:search])
    movie_array(json)
  end

  def movie_array(json)
    json[:results].map do |result|
      Movie.new(result)
    end
  end
end

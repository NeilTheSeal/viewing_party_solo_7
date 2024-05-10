class MoviesController < ApplicationController
  def index
    @facade = MovieFacade.new(params)
  end
end

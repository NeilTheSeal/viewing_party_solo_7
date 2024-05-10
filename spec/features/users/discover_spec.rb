require "rails_helper"

RSpec.describe "Discover Movies" do
  before(:each) do
    @user = User.create!(
      name: "Neil H",
      email: "neil.h@somewhere.com"
    )
  end

  it "can list the most popular movies" do
    VCR.use_cassette("popular_movies", serialize_with: :json) do |cassette|
      visit "/users/#{@user.id}/discover"

      click_link "Top Rated Movies"

      expect(page).to have_current_path(
        "/users/#{@user.id}/movies",
        ignore_query: true
      )
      expect(page.status_code).to eq 200

      body = JSON.parse(
        cassette.serializable_hash.dig(
          "http_interactions", 0, "response", "body", "string"
        ),
        symbolize_names: true
      )

      movies = body[:results]

      within "#movies" do
        expect(page).to have_css(".movie-info", count: 20)
        expect(page).to have_css("a", count: 20)
        movies.each do |movie|
          expect(page).to have_content(movie[:title])
        end
      end
    end
  end

  it "can find a movie by title search", :vcr do
    VCR.use_cassette("movie_search", serialize_with: :json) do |cassette|
      visit "/users/#{@user.id}/discover"

      fill_in :search, with: "Super Troopers"
      click_button "Search"

      expect(page).to have_current_path(
        "/users/#{@user.id}/movies",
        ignore_query: true
      )

      expect(page.status_code).to eq 200

      body = JSON.parse(
        cassette.serializable_hash.dig(
          "http_interactions", 0, "response", "body", "string"
        ),
        symbolize_names: true
      )

      movies = body[:results]

      expect(page).to have_content(movies[0][:title])
      expect(page).to have_content(movies[1][:title])
      expect(page).to have_content(movies[2][:title])
    end
  end
end

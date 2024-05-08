require "rails_helper"

RSpec.describe "Discover Movies" do
  before(:each) do
    @user = User.create!(
      name: "Neil H",
      email: "neil.h@somewhere.com"
    )
  end

  it "can list the most popular movies" do
    json_response = File.read("spec/fixtures/popular_movies.json")
    stub_request(
      :get,
      "https://api.themoviedb.org/3/discover/movie"
    ).to_return(status: 200, body: json_response)

    visit "/users/#{@user.id}/discover"

    click_button "Top Rated Movies"

    expect(page).to have_current_path("/users/#{@user.id}/movies")
    expect(page.status_code).to eq 200
    expect(page).to have_content("Godzilla Minus One")
    expect(page).to have_content("Godzilla x Kong: The New Empire")
    expect(page).to have_content("Kingdom of the Planet of the Apes")
    expect(page).to have_content("Dune: Part Two")
    expect(page).to have_content("The Idea of You")
    expect(page).to have_content("Ape vs. Mecha Ape")
    expect(page).to have_content("Monster's Battlefield")
  end

  it "can find a movie by title search" do
    json_response = File.read("spec/fixtures/movie_search.json")
    stub_request(
      :get,
      "https://api.themoviedb.org/3/search/movie"
    ).to_return(status: 200, body: json_response)

    visit "/users/#{@user.id}/discover"

    fill_in :search, with: "Super Troopers"
    click_button "Search"

    expect(page).to have_current_path("/users/#{@user.id}/movies")
    expect(page.status_code).to eq 200
    expect(page).to have_content("Super Troopers")
    expect(page).to have_content("Super Troopers 2")
    expect(page).to have_content("Super Troopers 3: Winter Soldiers")
  end
end

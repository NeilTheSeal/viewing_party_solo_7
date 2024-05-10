require "rails_helper"

RSpec.describe "Discover Movies" do
  before(:each) do
    @user = User.create!(
      name: "Neil H",
      email: "neil.h@somewhere.com"
    )
  end

  it "can list the most popular movies", :vcr do
    # VCR.use_cassette("name_of_cassette") do

    # end
    visit "/users/#{@user.id}/discover"

    click_link "Top Rated Movies"

    expect(page).to have_current_path("/users/#{@user.id}/movies")
    expect(page.status_code).to eq 200
    within "#movies" do
      expect(page).to have_css(".movie-info", count: 20)
      expect(page).to have_css("a", count: 20)
    end
  end

  it "can find a movie by title search", :vcr do
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

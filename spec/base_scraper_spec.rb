require_relative "../lib/base_scraper.rb"

describe "#scrape_index_page" do
  it "is a class method that scrapes the student index page and a returns an array of hashes in which each hash represents one student" do
    index_url = "http://dealnews.com/black-friday/index.html"
    scraped_students = Scraper.scrape_index_page(index_url)
    expect(scraped_students).to be_a(Array)
    expect(scraped_students.first).to have_key(:page_url)
    expect(scraped_students.first).to have_key(:name)
    #expect(scraped_students).to include(student_index_array[0], student_index_array[1], student_index_array[2])
  end
end

describe "#scrape_profile_page" do
  it "is a class method that scrapes a student's profile page and returns a hash of attributes describing an individual student" do
    profile_url = "http://dealnews.com/black-friday/s5843/Dollar-General/"
    scraped_student = Scraper.scrape_profile_page(profile_url)
    expect(scraped_student).to be_a(Array)
    #expect(scraped_student).to match(student_joe_hash)
  end
end

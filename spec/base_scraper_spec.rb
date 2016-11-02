require_relative "../lib/base_scraper.rb"

describe "#scrape_index_page" do
  it "is a class method that scrapes the index page and a returns an array of hashes in which each hash represents one deal vendor" do
    index_url = "http://dealnews.com/black-friday/index.html"
    scraped_index_page = Scraper.scrape_index_page(index_url)
    expect(scraped_index_page).to be_a(Array)
    expect(scraped_index_page.first).to have_key(:vendor_url)
    expect(scraped_index_page.first).to have_key(:vendor_name)
  end
end

describe "#scrape_vendor_page" do
  it "is a class method that scrapes a vendor's profile page and returns a hash of attributes for that deal page" do
    page_url = "http://dealnews.com/black-friday/s638/Dell-Home/"
    scraped_page = Scraper.scrape_vendor_page(page_url)
    expect(scraped_page).to be_a(Array)
  end
end

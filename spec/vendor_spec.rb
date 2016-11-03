require_relative "../lib/base_scraper.rb"
require_relative "../lib/vendor.rb"

describe "#scrape_index_page" do
  it "xyz" do
    index_url = "http://dealnews.com/black-friday/index.html"
    scraped_index_page = Scraper.scrape_index_page(index_url)
    Vendor.create_from_collection(scraped_index_page)
    Vendor.all
    #Vendor.return_deal_url(3)
    #expect(scraped_index_page).to be_a(Array)

  end
end

require_relative "../lib/blackfriday2016/base_scraper.rb"
require_relative "../lib/blackfriday2016/deals.rb"

describe "#scrape_index_page" do
  it "xyz" do
    page_url = "/black-friday/s1320/Ace-Hardware/"
    Dealpage.new(page_url)
    #Deals.separate_deals_into_pages

  end
end

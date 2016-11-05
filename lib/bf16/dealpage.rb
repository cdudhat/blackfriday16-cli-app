require_relative '../bf16/vendor.rb'
require 'pry'

class Dealpage

  attr_accessor :prev_page_link, :next_page_link, :pagenum, :deals
  DEALS_BASE_PATH = "http://dealnews.com"


  def initialize(deal_page_complete)
    deal_page_complete.each {|key,value| self.send(("#{key}="), value)}
  end

  def self.create_new_dealpage(page_url)
    deal_page_complete = Scraper.scrape_vendor_page(DEALS_BASE_PATH + page_url)
    Dealpage.new(deal_page_complete)
  end

  def self.next_page

  end

  def self.all
    @@all
  end

  def self.page_count
    (self.all.count/10.to_f).ceil
  end

  def self.separate_deals_into_pages
    deal_pages = []
    counter = 0
    length = 10
    while (counter/10) < self.page_count
      deal_page = {
        :page_num => (counter/10)+1,
        :deals => @@all[counter, length]
      }
      counter+=10
      deal_pages << deal_page
    end
    deal_pages
  end

  def self.display_deal_details(page_num=1)
    self.separate_deals_into_pages.each do |deal_page|
      if deal_page.fetch(:page_num) == page_num
        deal_page.fetch(:deals).each do |deal|
          puts "# ".colorize(:light_red) + deal[0].colorize(:light_blue) + " - ".colorize(:light_red) + deal[1]
        end
      end
    end
  end

end

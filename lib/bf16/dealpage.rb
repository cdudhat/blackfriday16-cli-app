require_relative './vendor.rb'
require 'pry'

class Dealpage

  attr_accessor :prev_page_link, :next_page_link, :pagenum, :deals, :vendor_name
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

  #Display each deal page with deals from each page as scraped
  def self.display_deal_details(page_url)
    current_page = self.create_new_dealpage(page_url)
    puts "-------------------------------------------------------".colorize(:light_blue)
    puts "#{current_page.vendor_name} - Deals - Page #{current_page.pagenum}:".center(55)
    puts "-------------------------------------------------------".colorize(:light_blue)
    current_page.deals.each do |deal|
      puts "# ".colorize(:light_red) + deal[0].colorize(:light_blue) + " - ".colorize(:light_red) + deal[1]
    end
    self.display_page_options(page_url)
  end

  def self.print_prev_page
    print "| '" + "p".colorize(:light_red) + "' <<< " + "Previous Page".colorize(:light_blue) + " |"
  end

  def self.print_next_page
    print "| '" + "n".colorize(:light_red) + "' >>> " + "Next Page".colorize(:light_blue) + " |"
  end

  #Display deal page options
  def self.display_page_options(page_url)
    puts "-------------------------------------------------------".colorize(:light_blue)
    current_page = self.create_new_dealpage(page_url)
    nextpage_url = current_page.next_page_link
    prevpage_url = current_page.prev_page_link
    puts "Please select from options below:".colorize(:green)
    self.print_prev_page if prevpage_url != nil
    self.print_next_page if nextpage_url != nil
    puts "\n" + "| '" + "s".colorize(:light_red) + "' to go back to the " + "Store Listing".colorize(:light_blue) + " |"
    puts "| '" + "x".colorize(:light_red) + "' to " + "Exit".colorize(:light_blue) + " the program |"
    print "\n" + "Please Enter your selection: ".colorize(:green)
    input = gets.strip.downcase
    if input == "n"
      nextpage_url = self.create_new_dealpage(page_url).next_page_link
      if nextpage_url != nil
        self.display_deal_details(nextpage_url)
      elsif nextpage_url == nil
        puts "You have reached the end of Deal Listings of this Store.".colorize(:light_blue)
        self.display_page_options(page_url)
      end
    elsif input == "p"
      if prevpage_url != nil
        self.display_deal_details(prevpage_url)
      elsif prevpage_url == nil
        puts "You have reached the beginning of Deal Listings of this Store.".colorize(:light_blue)
        self.display_page_options(page_url)
      end
    elsif input == "s"
      Vendor.display_vendors
    elsif input == "x"
      puts "Goodbye! Have a nice day.".colorize(:light_blue)
    else
      puts "You have entered an invalid choice. Please make a valid choice.".colorize(:light_blue)
      self.display_page_options(page_url)
    end
  end

end

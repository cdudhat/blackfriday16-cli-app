require_relative "../lib/base_scraper.rb"
require_relative "../lib/vendor.rb"
require_relative "../lib/dealpage.rb"
require 'nokogiri'
require 'colorize'

class CommandLineInteface
  INDEX_BASE_PATH = "http://dealnews.com/black-friday/"
  DEALS_BASE_PATH = "http://dealnews.com"
  @store_num = nil

  def run
    puts "Welcome to 2016 Black Friday Deal Listings!"
    create_vendors
    display_vendors
    #index_page_options(1)
    #display_deal_details(Vendor.return_deal_url(3))
  end

  def create_vendors
    vendor_index = Scraper.scrape_index_page(INDEX_BASE_PATH)# + 'index.html')
    Vendor.create_from_collection(vendor_index)
  end

  def display_vendors(page_num=1)
    Vendor.all.each do |vendor|
      puts "#{vendor.number}. ".colorize(:light_blue) + "#{vendor.name}" if vendor.index_pagenum == page_num
    end
    index_page_options(page_num)
  end

  def index_page_options(page_num=1)
    puts "Please select from options below:"
    puts "Enter 'n' for Next Page" if page_num < Vendor.page_count
    puts "Enter 'p' for Previous Page" if (page_num > 1 && page_num <= Vendor.page_count)
    puts "Enter 'd' to see deals from a particular store"
    puts "Or Enter 'x' to exit the program"
    print "Please Enter your selection: "
    input = gets.strip.downcase
    if input == "n"
      display_vendors(page_num+1)
    elsif input == "p"
      display_vendors(page_num-1)
    elsif input == "d"
      print "Enter the Store Number: "
      @store_num = gets.strip.to_i
      #if Vendor.return_deal_url(input) != nil
      display_deal_details(Vendor.return_deal_url(@store_num))
      #else
      #  puts "You have entered an invalid Store Number. Please make a valid choice."
      #  index_page_options(page_num)
      #end
      #binding.pry

    elsif input == "x"
      puts "Goodbye! Have a nice day."
    else
      puts "You have entered an invalid choice. Please make a valid choice."
      index_page_options(page_num)
    end
  end

  def display_page_options(page_url)
    current_page = Dealpage.create_new_dealpage(page_url)
    nextpage_url = current_page.next_page_link
    prevpage_url = current_page.prev_page_link
    puts "Please select from options below:"
    puts "Enter 'n' for Next Page" if nextpage_url != nil
    puts "Enter 'p' for Previous Page" if prevpage_url != nil
    puts "Enter 'i' to go back to the index page"
    puts "Or Enter 'x' to exit the program"
    print "Please Enter your selection: "
    input = gets.strip.downcase
    if input == "n"
      nextpage_url = Dealpage.create_new_dealpage(page_url).next_page_link
      display_deal_details(nextpage_url) if nextpage_url != nil
      puts "You have reached the end" if nextpage_url == nil
    elsif input == "p"
      display_deal_details(page_num-1)
    elsif input == "i"
      display_vendors
    elsif input == "x"
      puts "Goodbye! Have a nice day."
    else
      puts "You have entered an invalid choice. Please make a valid choice."
      display_page_options
    end
  end

  #To be used if each deal page was being scraped as called for
  def display_deal_details(page_url)
    current_page = Dealpage.create_new_dealpage(page_url)
    #binding.pry
    current_page.deals.each do |deal|
      puts "# ".colorize(:light_red) + deal[0].colorize(:light_blue) + " - ".colorize(:light_red) + deal[1]
    end
    display_page_options(page_url)
  end

  #To be used if all deals were being printed at once without Deals class
  #def display_deal_details(page_url)
  #  deal_details = Scraper.scrape_vendor_page(DEALS_BASE_PATH + page_url)
  #  deal_details.each do |deal|
  #    puts "# ".colorize(:light_red) + deal[0].colorize(:light_blue) + " - " + deal[1]
  #  end
  #end

  #def display_deal_details(page_url)
  #  Deals.new(page_url)
  #  Deals.separate_deals_into_pages
  #  Deals.display_deal_details

  #  #deal_pages.each do |deal_page|
  #  #  deal_page.fetch(:deals).each do |deal|
  #  #    puts "# ".colorize(:light_red) + deal[0].colorize(:light_blue) + " - ".colorize(:light_red) + deal[1]
  #  #  end
  #  #end

  #end

end

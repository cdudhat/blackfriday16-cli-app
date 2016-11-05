require_relative "../lib/bf16/base_scraper.rb"
require_relative "../lib/bf16/vendor.rb"
require_relative "../lib/bf16/dealpage.rb"
require 'nokogiri'
require 'colorize'

class CommandLineInteface
  INDEX_BASE_PATH = "http://dealnews.com/black-friday/"
  DEALS_BASE_PATH = "http://dealnews.com"

  def run
    puts "-------------------------------------------------------".colorize(:light_blue)
    puts "Welcome to 2016 Black Friday Deal Listings!".colorize(:light_red).center(70)
    create_vendors
    display_vendors
  end

  def create_vendors
    vendor_index = Scraper.scrape_index_page(INDEX_BASE_PATH)# + 'index.html')
    Vendor.create_from_collection(vendor_index)
  end

  def display_vendors(page_num=1)
    puts "-------------------------------------------------------".colorize(:light_blue)
    puts "List of Stores offering Black Friday Deals - Page #{page_num}:".center(55)
    puts "-------------------------------------------------------".colorize(:light_blue)
    Vendor.all.each do |vendor|
      puts "#{vendor.number}. ".colorize(:light_red) + "#{vendor.name}".colorize(:light_blue) if vendor.index_pagenum == page_num
    end
    index_page_options(page_num)
  end

  def print_prev_page
    print "| '" + "p".colorize(:light_red) + "' <<< " + "Previous Page".colorize(:light_blue) + " |"
  end

  def print_next_page
    print "| '" + "n".colorize(:light_red) + "' >>> " + "Next Page".colorize(:light_blue) + " |"
  end

  def index_page_options(page_num=1)
    puts "-------------------------------------------------------".colorize(:light_blue)
    puts "Please select from options below:"
    print_prev_page if (page_num > 1 && page_num <= Vendor.page_count)
    print_next_page if page_num < Vendor.page_count
    puts "\n" + "| Store '" + "#".colorize(:light_red) + "' to " + "See Deals".colorize(:light_blue) + " from a particular Store |"
    puts "| '" + "x".colorize(:light_red) + "' to " + "Exit".colorize(:light_blue) + " the program |"
    print "\n" + "Please Enter your selection: "
    input = gets.strip.downcase
    if input == "n"
      display_vendors(page_num+1)
    elsif input == "p"
      display_vendors(page_num-1)
    elsif input.include?(".")
      puts "You have entered an invalid choice. Please make a valid choice."
      index_page_options(page_num)
    elsif input.to_i > 0
      store_num = input.to_i
      if store_num <= Vendor.all.count
        display_deal_details(Vendor.return_deal_url(store_num))
      else
        puts "You have entered an invalid Store Number. Please make a valid choice."
        index_page_options(page_num)
      end
    elsif input == "x"
      puts "Goodbye! Have a nice day."
    else
      puts "You have entered an invalid choice. Please make a valid choice."
      index_page_options(page_num)
    end
  end

  def display_page_options(page_url)
    puts "-------------------------------------------------------".colorize(:light_blue)
    current_page = Dealpage.create_new_dealpage(page_url)
    nextpage_url = current_page.next_page_link
    prevpage_url = current_page.prev_page_link
    puts "Please select from options below:"
    print_prev_page if prevpage_url != nil
    print_next_page if nextpage_url != nil
    puts "\n" + "| '" + "s".colorize(:light_red) + "' to go back to the " + "Store Listing".colorize(:light_blue) + " |"
    puts "| '" + "x".colorize(:light_red) + "' to " + "Exit".colorize(:light_blue) + " the program |"
    print "\n" + "Please Enter your selection: "
    input = gets.strip.downcase
    if input == "n"
      nextpage_url = Dealpage.create_new_dealpage(page_url).next_page_link
      display_deal_details(nextpage_url) if nextpage_url != nil
      puts "You have reached the end of listings" if nextpage_url == nil
      display_page_options(page_url)
    elsif input == "p"
      display_deal_details(prevpage_url) if prevpage_url != nil
      puts "You have reached the beginning of listings" if prevpage_url == nil
      display_page_options(page_url)
    elsif input == "s"
      display_vendors
    elsif input == "x"
      puts "Goodbye! Have a nice day."
    else
      puts "You have entered an invalid choice. Please make a valid choice."
      display_page_options(page_url)
    end
  end

  #To be used if each deal page was being scraped as called for
  def display_deal_details(page_url)
    puts "-------------------------------------------------------".colorize(:light_blue)
    current_page = Dealpage.create_new_dealpage(page_url)
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

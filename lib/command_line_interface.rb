require_relative "../lib/base_scraper.rb"
require_relative "../lib/vendor.rb"
require 'nokogiri'
require 'colorize'

class CommandLineInteface
  INDEX_BASE_PATH = "http://dealnews.com/black-friday/"
  DEALS_BASE_PATH = "http://dealnews.com"

  def run
    puts "Welcome to 2016 Black Friday Deal Listings!"
    create_vendors
    display_vendors(1)
    #index_page_options(1)
    #display_deal_details(Vendor.return_deal_url(3))
  end

  def create_vendors
    vendor_index = Scraper.scrape_index_page(INDEX_BASE_PATH)# + 'index.html')
    Vendor.create_from_collection(vendor_index)
  end

  def display_vendors(page_num)
    Vendor.all.each do |vendor|
      case page_num
      when 1
        puts "#{vendor.number}. ".colorize(:light_blue) + "#{vendor.name}" if vendor.number.between?(1, 10)
      when 2
        puts "#{vendor.number}. #{vendor.name}" if vendor.number.between?(11, 20)
      when 3
        puts "#{vendor.number}. #{vendor.name}" if vendor.number.between?(21, 30)
      when 4
        puts "#{vendor.number}. #{vendor.name}" if vendor.number.between?(31, 40)
      end
    end
    index_page_options(page_num)
  end

  def index_page_options(page_num)
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
      store_num = gets.strip.to_i
      #if Vendor.return_deal_url(input) != nil
      display_deal_details(Vendor.return_deal_url(store_num))
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

  def display_page_options(page_num)
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
      store_num = gets.strip.to_i
      #if Vendor.return_deal_url(input) != nil
      display_deal_details(Vendor.return_deal_url(store_num))
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

  def display_deal_details(page_url)
    deal_details = Scraper.scrape_vendor_page(DEALS_BASE_PATH + page_url)
    deal_details.fetch(:deals).each do |deal|
      puts "# ".colorize(:light_red) + deal[0].colorize(:light_blue) + " - " + deal[1]
    end
  end

  #def display_deal_details(page_url)
  #  deal_details = Scraper.scrape_vendor_page(DEALS_BASE_PATH + page_url)
  #  deal_details.each do |deal|
  #    puts "#{deal[0]} - #{deal[1]}"
  #  end
  #end

end

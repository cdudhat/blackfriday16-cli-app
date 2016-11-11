#require_relative "./base_scraper.rb"
#require_relative './dealpage.rb'
require 'pry'

class Vendor
  attr_accessor :number, :name, :page_url, :index_pagenum
  INDEX_BASE_PATH = "http://dealnews.com/black-friday/"
  @@all = []

  #Initializes each of the vendor attributes
  def initialize(vendor_details)
    vendor_details.each {|key,value| self.send(("#{key}="), value)}
    @@all << self
  end

  #Uses the Scraper class to create new vendors with all the details
  def self.create_from_collection(vendor_index)
    vendor_index.each do |vendor|
      self.new(vendor)
    end
  end

  #Scrapes from the index page, and creates vendors
  def self.create_vendors
    vendor_index = Scraper.scrape_index_page(INDEX_BASE_PATH)# + 'index.html')
    self.create_from_collection(vendor_index)
  end

  def self.all
    @@all
  end

  #Count the total number of vendor index pages
  def self.page_count
    (self.all.count/10.to_f).ceil
  end

  #Returns the deal page url of a particular vendor
  def self.return_deal_url(input)
    return_url = nil
    self.all.each do |vendor|
      return_url = vendor.page_url if vendor.number == input
    end
    return_url
  end

  #Returns vendor name when given a deal page url
  def self.return_vendor_name(page_url)
    vendor_name = nil
    self.all.each do |vendor|
      vendor_name = vendor.name if vendor.page_url == page_url
    end
    vendor_name
  end

  #Displays list of Stores
  def self.display_vendors(page_num=1)
    puts "-------------------------------------------------------".colorize(:light_blue)
    puts "List of Stores - Black Friday Deals - Page #{page_num}:".center(55)
    puts "-------------------------------------------------------".colorize(:light_blue)
    self.all.each do |vendor|
      puts "#{vendor.number}. ".colorize(:light_red) + "#{vendor.name}".colorize(:light_blue) if vendor.index_pagenum == page_num
    end
    self.index_page_options(page_num)
  end

  #Prints Previous Page indicator
  def self.print_prev_page
    print "| '" + "p".colorize(:light_red) + "' <<< " + "Previous Page".colorize(:light_blue) + " |"
  end

  #Prints Next Page indicator
  def self.print_next_page
    print "| '" + "n".colorize(:light_red) + "' >>> " + "Next Page".colorize(:light_blue) + " |"
  end

  #Method to display next page of stores list if applicable
  def self.go_to_next_page(page_num)
    if page_num+1 <= self.page_count
      self.display_vendors(page_num+1)
    else
      puts "You have reached the end of Store List.".colorize(:light_blue)
      self.index_page_options(page_num)
    end
  end

  #Method to display previous page of stores list if applicable
  def self.go_to_prev_page(page_num)
    if page_num-1 >= 1
      self.display_vendors(page_num-1)
    else
      puts "You have reached the beginning of Store List.".colorize(:light_blue)
      self.index_page_options(page_num)
    end
  end

  #Method to display the first page of deals of a particular selected store
  def self.go_to_store_deals(store_num, page_num)
    if store_num <= self.all.count
      Dealpage.display_deal_details(self.return_deal_url(store_num))
    else
      puts "You have entered an invalid Store Number. Please make a valid choice.".colorize(:light_blue)
      self.index_page_options(page_num)
    end
  end

  #Display Store List menu options
  def self.index_page_options(page_num=1)
    puts "-------------------------------------------------------".colorize(:light_blue)
    puts "Please select from options below:".colorize(:green)
    self.print_prev_page if (page_num > 1 && page_num <= self.page_count)
    self.print_next_page if page_num < self.page_count
    puts "\n" + "| Store '" + "#".colorize(:light_red) + "' to " + "See Deals".colorize(:light_blue) + " from a particular Store |"
    puts "| '" + "x".colorize(:light_red) + "' to " + "Exit".colorize(:light_blue) + " the program |"
    print "\n" + "Please Enter your selection: ".colorize(:green)
    input = gets.strip.downcase
    if input == "n"
      self.go_to_next_page(page_num)
    elsif input == "p"
      self.go_to_prev_page(page_num)
    elsif (input.include?(".") || input.include?(",")) #To make float inputs invalid
      puts "You have entered an invalid choice. Please make a valid choice.".colorize(:light_blue)
      self.index_page_options(page_num)
    elsif input.to_i > 0
      store_num = input.to_i
      self.go_to_store_deals(store_num, page_num)
    elsif input == "x"
      puts "Goodbye! Have a nice day.".colorize(:light_blue)
    else
      puts "You have entered an invalid choice. Please make a valid choice.".colorize(:light_blue)
      self.index_page_options(page_num)
    end
  end

end

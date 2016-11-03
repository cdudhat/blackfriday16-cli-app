require_relative "../lib/base_scraper.rb"
require_relative "../lib/vendor.rb"
require 'nokogiri'
require 'colorize'

class CommandLineInteface
  BASE_PATH = "http://dealnews.com/black-friday/"

  def run
    create_vendors
    display_vendors(1)
    #display_deal_details("http://dealnews.com/black-friday/s638/Dell-Home/")
  end

  def create_vendors
    vendor_index = Scraper.scrape_index_page(BASE_PATH + 'index.html')
    Vendor.create_from_collection(vendor_index)
  end

  def total_vendor_page_number
    (Vendor.all.count/10.to_f).ceil
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
    puts "Enter Vendor:"
    input = gets.strip
    Vendor.all.each do |vendor|
      vendor.page_url if vendor.number == input
    end
  end

  def display_deal_details(page_url)
    deal_details = Scraper.scrape_vendor_page(page_url)
    deal_details.each do |deal|
      puts "#{deal[0]} - #{deal[1]}"
    end
  end

end

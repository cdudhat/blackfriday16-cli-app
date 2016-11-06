require 'pry'

class Vendor
  attr_accessor :number, :name, :page_url, :index_pagenum
  @@all = []

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

  def self.all
    @@all
  end

  #Count the total number of vendor index pages
  def self.page_count
    (self.all.count/10.to_f).ceil
  end

  def self.return_deal_url(input)
    return_url = nil
    self.all.each do |vendor|
      return_url = vendor.page_url if vendor.number == input
    end
    return_url
  end

  def self.return_vendor_name(page_url)
    vendor_name = nil
    self.all.each do |vendor|
      vendor_name = vendor.name if vendor.page_url == page_url
    end
    vendor_name
  end

end

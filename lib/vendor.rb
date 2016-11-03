require 'pry'

class Vendor
  attr_accessor :number, :name, :page_url
  @@all = []

  def initialize(vendor_details)
    vendor_details.each {|key,value| self.send(("#{key}="), value)}
    @@all << self
  end

  #Uses the Scraper class to create new students with the correct name and location
  def self.create_from_collection(vendor_index)
    vendor_index.each do |vendor|
      self.new(vendor)
    end
    #binding.pry
  end

  def self.all
    @@all
  end

end

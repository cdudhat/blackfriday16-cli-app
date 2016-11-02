require 'nokogiri'
require 'open-uri'
require 'pry'

class Scraper

  def self.scrape_index_page(index_url)
    index_page = Nokogiri::HTML(open(index_url))

    vendor_index = []

    deal_page = index_page.css("div.simple-vendor-grid div.line.grid-line.content-line").each do |vendor_line|
      vendor_line.css("div.unit.tile.size1of3").each do |vendor|
        if vendor.css("div.content-box-hd").css("a").any?
          vendor_details = {
            :vendor_name => vendor.css("div.content-box-hd").css("a").text,
            :vendor_url => vendor.css("div.content-box-hd").css("a").attribute("href").value
          }
        else
          break
        end
        #binding.pry
        vendor_index << vendor_details
      end
    end
    #binding.pry
    vendor_index
  end

  #def self.scrape_vendor_page(vendor_url)
  #  deals_page = Nokogiri::HTML(open(vendor_url))

  #  prev_page = nil
  #  next_page = nil
  #  full_page_deals = []

  #  #Compile social media links
  #  main_container = deals_page.css("div.main.browsecontent")
  #  main_container.css("div.content-view.content-box.content-summary").each do |link|
  #    individual_deal = []
  #    deal_detail = link.css("div.unit.size3of4").css("h3.headline-xlarge a").text
  #    price_detail = link.css("div.unit.size3of4").css("div.content-call-out").text
  #    price_detail = "FREE" if price_detail == ""
  #    individual_deal << deal_detail << price_detail
  #    full_page_deals << individual_deal
  #  end

  #  pager = main_container.css("div.pager")
  #  prev_page = pager.css("a.pager-end[rel=prev]").attribute("href").value if pager.css("a.pager-end[rel=prev]").any?
  #  next_page = pager.css("a.pager-end[rel=next]").attribute("href").value if pager.css("a.pager-end[rel=next]").any?

  #  deal_page_complete = {
  #    :prev_page_link => prev_page,
  #    :next_page_link => next_page,
  #    :deals => full_page_deals
  #  }

  #  deal_page_complete
  #  binding.pry
  #end

  def self.scrape_vendor_page(vendor_url)

    next_page = vendor_url
    full_page_deals = []

    while next_page != nil do
      deals_page = Nokogiri::HTML(open(next_page))
      main_container = deals_page.css("div.main.browsecontent")
      pager = main_container.css("div.pager")

      main_container.css("div.content-view.content-box.content-summary").each do |link|
        individual_deal = []
        deal_detail = link.css("div.unit.size3of4").css("h3.headline-xlarge a").text
        price_detail = link.css("div.unit.size3of4").css("div.content-call-out").text.split(/\s/).first
        price_detail = "FREE" if price_detail == ""
        individual_deal << deal_detail << price_detail
        full_page_deals << individual_deal
      end

      if pager.css("a.pager-end[rel=next]").any?
        next_page = pager.css("a.pager-end[rel=next]").attribute("href").value
      else
        next_page = nil
      end

    end

    binding.pry
    full_page_deals
    #prev_page = pager.css("a.pager-end[rel=prev]").attribute("href").value if pager.css("a.pager-end[rel=prev]").any?
    #next_page = pager.css("a.pager-end[rel=next]").attribute("href").value if pager.css("a.pager-end[rel=next]").any?

    #deal_page_complete = {
    #  :prev_page_link => prev_page,
    #  :next_page_link => next_page,
    #  :deals => full_page_deals
    #}

    #deal_page_complete
    #binding.pry
  end
end

require 'nokogiri'
require 'open-uri'
require 'pry'

class Scraper

  def self.scrape_index_page(index_url)
    index_page = Nokogiri::HTML(open(index_url))#.css("div.main").css("div.simple-vendor-grid")[1]

    vendor_index = []
    counter = 1

    deal_page = index_page.css("h3+div.simple-vendor-grid")[1..-1].css("div.line.grid-line.content-line").each do |vendor_line|
      vendor_line.css("div.unit.tile.size1of3").each do |vendor|
        if vendor.css("div.content-box-hd").css("a").any?
          vendor_details = {
            :number => counter,
            :name => vendor.css("div.content-box-hd").css("a").text,
            :page_url => vendor.css("div.content-box-hd").css("a").attribute("href").value,
            :index_pagenum => (counter/10.to_f).ceil
          }
          counter+=1
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

  def self.scrape_vendor_page(vendor_url)
    deals_page = Nokogiri::HTML(open(vendor_url))

    #prev_page = String.new
    #next_page = String.new
    full_page_deals = []

    #Compile social media links
    main_container = deals_page.css("div.main.browsecontent")
    main_container.css("div.content-view.content-box.content-summary").each do |link|
      individual_deal = []
      deal_detail = link.css("div.unit.size3of4").css("h3.headline-xlarge a").text
      price_detail = link.css("div.unit.size3of4").css("div.content-call-out").text.strip.gsub(/\s+/, " ")
      price_detail = "FREE" if price_detail == ""
      individual_deal << deal_detail << price_detail
      full_page_deals << individual_deal
    end

    pager = main_container.css("div.pager")
    
    if pager.css("a.pager-end[rel=prev]").any?
      prev_page = pager.css("a.pager-end[rel=prev]").attribute("href").value.gsub("http://dealnews.com","")
    else
      prev_page = nil
    end

    if pager.css("a.pager-end[rel=next]").any?
      next_page = pager.css("a.pager-end[rel=next]").attribute("href").value.gsub("http://dealnews.com","")
    else
      next_page = nil
    end

    page_num = pager.css("strong.pager-link.pager-current").text

    deal_page_complete = {
      :prev_page_link => prev_page,
      :next_page_link => next_page,
      :pagenum => page_num.to_i,
      :deals => full_page_deals
    }

    deal_page_complete
  end

  #Shows all the deals of a particular vendor
  #def self.scrape_vendor_page(vendor_url)

  #  next_page = vendor_url
  #  full_page_deals = []

  #  while next_page != nil do
  #    deals_page = Nokogiri::HTML(open(next_page))
  #    main_container = deals_page.css("div.main.browsecontent")
  #    pager = main_container.css("div.pager")

  #    main_container.css("div.content-view.content-box.content-summary").each do |link|
  #      individual_deal = []
  #      deal_detail = link.css("div.unit.size3of4").css("h3.headline-xlarge a").text
  #      price_detail = link.css("div.unit.size3of4").css("div.content-call-out").text.strip.gsub(/\s+/, " ")
  #      price_detail = "FREE" if price_detail == ""
  #      individual_deal << deal_detail << price_detail
  #      full_page_deals << individual_deal
  #    end

  #    if pager.css("a.pager-end[rel=next]").any?
  #      next_page = pager.css("a.pager-end[rel=next]").attribute("href").value
  #    else
  #      next_page = nil
  #    end

  #  end
  #  full_page_deals
  #end

end

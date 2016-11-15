require 'nokogiri'
require 'open-uri'
require 'pry'

class Scraper

  def self.scrape_index_page(index_url)
    index_page = Nokogiri::HTML(open(index_url))#.css("div.main").css("div.simple-vendor-grid")[1]

    vendor_index = []
    counter = 1

    vendor_page = index_page.css("h3+div.simple-vendor-grid")[1..-1].css("div.line.grid-line.content-line").each do |vendor_line|
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
        vendor_index << vendor_details
      end
    end
    vendor_index
  end

  #Scrape Vendor's Deal Pages one by one as requested
  def self.scrape_vendor_page(vendor_url)
    deals_page = Nokogiri::HTML(open(vendor_url))

    full_page_deals = []

    #Compile deals from the page
    main_container = deals_page.css("div.dynamic-pager")
    main_container.css("div.content-view.content-box.content-summary").each do |link|
      individual_deal = []
      deal_detail = link.css("div.unit.size3of4").css("h3.headline-xlarge a").text
      price_detail = link.css("div.unit.size3of4").css("div.content-call-out").text.strip.gsub(/\s+/, " ")
      price_detail = "FREE" if price_detail == ""
      individual_deal << deal_detail << price_detail
      full_page_deals << individual_deal
    end

    #Collect page and page link details
    pager = main_container.css("div.pager")

    #Collect link to previous page, if it exists
    if pager.css("a.pager-end[rel=prev]").any?
      prev_page = pager.css("a.pager-end[rel=prev]").attribute("href").value.gsub("http://dealnews.com","")
    else
      prev_page = nil
    end

    #Collect link to next page, if it exists
    if pager.css("a.pager-end[rel=next]").any?
      next_page = pager.css("a.pager-end[rel=next]").attribute("href").value.gsub("http://dealnews.com","")
    else
      next_page = nil
    end

    #Collect current deal page number
    page_num = pager.css("strong.pager-link.pager-current").text
    page_num = "1" if (prev_page == nil && next_page == nil)

    #Collect Vendor name
    name = deals_page.css("div.banner-tagline h1").text.gsub(" Coupons & Promo Codes for Black Friday","")

    #Compile entire deal page Hash
    deal_page_complete = {
      :prev_page_link => prev_page,
      :next_page_link => next_page,
      :pagenum => page_num.to_i,
      :deals => full_page_deals,
      :vendor_name => name
    }

    deal_page_complete
  end

end

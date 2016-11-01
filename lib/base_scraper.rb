require 'nokogiri'
require 'open-uri'
require 'pry'

class Scraper

  def self.scrape_index_page(index_url)
    index_page = Nokogiri::HTML(open(index_url))

    deal_index = []

    deal_page = index_page.css("div.simple-vendor-grid div.line.grid-line.content-line").each do |deal_line|
      deal_line.css("div.unit.tile.size1of3").each do |deal|
        if deal.css("div.content-box-hd").css("a").any?
          deal_details = {
            :name => deal.css("div.content-box-hd").css("a").text,
            :page_url => deal.css("div.content-box-hd").css("a").attribute("href").value
          }
        else
          break
        end
        #binding.pry
        deal_index << deal_details
      end
    end
    deal_index
  end

  def self.scrape_profile_page(page_url)
    deals_page = Nokogiri::HTML(open(page_url))

    page_hash = {}
    specific_deals = []

    #Compile social media links
    main_container = deals_page.css("div.main.browsecontent")
    main_container.css("div.content-view.content-box.content-summary").each do |link|
      individual_deal = []
      deal_details = link.css("div.unit.size3of4").css("h3.headline-xlarge a").text
      price_details = link.css("div.unit.size3of4").css("div.content-call-out").text
      price_details = "FREE" if price_details == ""
      individual_deal << deal_details << price_details
      specific_deals << individual_deal
    end

    prev_page = nil
    next_page = nil
    pager = main_container.css("div.pager")
    prev_page = pager.css("a.pager-end[rel=prev]").attribute("href").value if pager.css("a.pager-end[rel=prev]").any?
    next_page = pager.css("a.pager-end[rel=next]").attribute("href").value if pager.css("a.pager-end[rel=next]").any?

    deal_page_complete = {
      :prev_page_link => prev_page,
      :next_page_link => next_page,
      :deals => specific_deals
    }

    deal_page_complete
    binding.pry
  end

  #  #Profile Quote
  #  quote_container = profile_page.css("div.vitals-text-container")
  #  profile[:profile_quote] = quote_container.css("div.profile-quote").text

  #  #Bio
  #  detail_container = profile_page.css("div.details-container")
  #  profile[:bio] = detail_container.css("div.bio-content.content-holder div.description-holder p").text

  #  profile
  #end

end

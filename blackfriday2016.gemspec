# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
#require 'regatta_results/version'

Gem::Specification.new do |s|
  s.name        = 'blackfriday2016'
  s.version     = '0.0.3'
  s.date        = '2016-11-07'
  s.summary     = "Black Friday 2016!"
  s.description = "A simple gem listing Black Friday Deals from various stores"
  s.authors     = ["Chirag D"]
  s.email       = 'chirag_3030@yahoo.com'
  s.files       = ["lib/blackfriday2016.rb", "lib/bf16/base_scraper.rb", "lib/bf16/dealpage.rb", "lib/bf16/vendor.rb", "config/environment.rb" ]
  s.homepage    = 'http://rubygems.org/gems/blackfriday2016'
  s.license     = 'MIT'
  s.executables << 'blackfriday2016'

  s.add_development_dependency "bundler", "~> 1.13"
  s.add_development_dependency "rake", "~> 11.3"
  s.add_development_dependency "rspec", "~> 0"
  s.add_development_dependency "pry", "~> 0"
  s.add_runtime_dependency "nokogiri", ">= 0"
  s.add_runtime_dependency "colorize", "~> 0.8"
end

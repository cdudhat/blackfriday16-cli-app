
Gem::Specification.new do |s|
  s.name        = 'blackfriday2016'
  s.version     = '0.0.2'
  s.date        = '2016-11-05'
  s.summary     = "Black Friday 2016!"
  s.description = "A simple gem listing Black Friday Deals from various stores"
  s.authors     = ["Chirag D"]
  s.email       = 'chirag_3030@yahoo.com'
  s.files       = ["lib/blackfriday2016.rb", "lib/bf16/base_scraper.rb", "lib/bf16/dealpage.rb", "lib/bf16/vendor.rb", "config/environment.rb" ]
  s.homepage    = 'http://rubygems.org/gems/blackfriday2016'
  s.license     = 'MIT'
  s.executables << 'blackfriday2016'

  s.add_development_dependency "bundler", "~> 1.10"
  s.add_development_dependency "rake", "~> 10.0"
  s.add_development_dependency "rspec", ">= 0"
  s.add_development_dependency "nokogiri", ">= 0"
  s.add_development_dependency "pry", ">= 0"
end

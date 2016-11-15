# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |s|
  s.name        = 'blackfriday2016'
  s.version     = '0.1.4'
  s.date        = '2016-11-14'
  s.summary     = "Black Friday 2016!"
  s.description = "A simple gem listing Black Friday Deals from various stores"
  s.authors     = ["Chirag Dudhat"]
  s.email       = 'cdudhat@gmail.com'
  s.homepage    = 'https://github.com/cdudhat/blackfriday16-cli-app'
  s.license     = 'MIT'

  s.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  #s.bindir        = "exe"
  s.executables   = "blackfriday2016"
  s.require_paths = ["lib"]

  s.add_development_dependency "bundler", "~> 1.13"
  s.add_development_dependency "rake", "~> 11.3"
  s.add_development_dependency "rspec", "~> 0"
  s.add_development_dependency "pry", "~> 0"
  s.add_runtime_dependency "nokogiri", "~> 1.6"
  s.add_runtime_dependency "colorize", "~> 0.8"
end

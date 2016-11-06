require_relative '../config/environment'

class CommandLineInteface

  def run
    puts "-------------------------------------------------------".colorize(:light_blue)
    puts "Welcome to 2016 Black Friday Deal Listings!".colorize(:light_red).center(70)
    Vendor.create_vendors
    Vendor.display_vendors
    puts "\n" + "-----------------------".colorize(:light_blue) + "THE-END".colorize(:light_red) + "-------------------------".colorize(:light_blue)
  end

end

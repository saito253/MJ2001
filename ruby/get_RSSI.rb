#!/usr/bin/ruby
require 'time'
require "csv"

begin 
    csvfile = CSV.open('rssi.csv','w')

    Dir.glob("*.log") { |f|
        File.foreach(f){|line|
          str = line.split(" ")
          if line.match("Rx rssi") then
            @rssi = str[8].to_i
          end
        }
        csvfile.puts [f,@rssi]
    }
    csvfile.close
end

#!/usr/bin/ruby
require 'time'
require "csv"

#
# cd log-directry
# % ruby C:\201-lazurite\MJ2001\software\ruby\get_procTimeAll.rb

CALIB   = "Calibration Summary"
OBW     = "01 Tolerance of occupied bandwidth"
FREQ    = "02 Tolerance of frequency"
POWER   = "03 Antenna power pointn"
SPURIOUS= "06 Tolerance of spurious"
ADJACENT= "07 Tolerance off adjacent channel leakage"
CCA     = "09 Career sense"
MASK    = "10 Spectrum emission mask"
ANNTENA = "Anntena test"
FINISH  = "RF test finished"

begin 
    csvfile = CSV.open('t108.csv','w')

    csvfile.puts ["Log file name",
                  "Calibration Summary:",
                  "01 Tolerance of occupied bandwidth:",
                  "",
                  "",
                  "02 Tolerance of frequency:",
                  "03 Antenna power pointn:",
                  "06 Tolerance of spurious:",
                  "",
                  "",
                  "07 Tolerance off adjacent channel leakage:",
                  "",
                  "09 Career sense:",
#                 "10 Spectrum emission mask:",
#                 "",
#                 "",
#                 "",
                  "Anntena test:"
                  ]

    csvfile.puts ["",
                  "",                       #Calibration Summary:
                  "OBW Center",             #01 Tolerance of occupied bandwidth:
                  "",   #"OBW Lower",
                  "",   #"OBW Upper",
                  "Frequency counter",      #02 Tolerance of frequency:
                  "Result",                 #03 Antenna power pointn:
                  "1   1",                  #06 Tolerance of spurious:
                  "2   2",                      
                  "3   3",                      
                  "Upper:",                 #07 Tolerance off adjacent channel leakage:
                  "Lower:",         
                  "",                       #09 Career sense:
#                 "Lower peak",             #10 Spectrum emission mask:
#                 "Upper peak",
#                 "Lower peak",
#                 "Upper peak",
                  "RSSI"                    #Anntena test:
                  ]

    csvfile.puts ["",
                  "",                       #Calibration Summary:
                  924300000,                #01 Center Frequency
                  (20 * (10**-6)),          #01 DEV
                  (924300000 * 20 * (10**-6)).to_i,          #01 DEV
                  "",                       #02 Tolerance of frequency:
                  "13",                     #03 Antenna power pointn:
                  "-36",                    #06 Tolerance of spurious:
                  "-36",                      
                  "-36",                      
                  "-26",                    #07 Tolerance off adjacent channel leakage:
                  "-26",         
                  "",                       #09 Career sense:
#                 "Lower peak",             #10 Spectrum emission mask:
#                 "Upper peak",
#                 "Lower peak",
#                 "Upper peak",
                  "RSSI"                    #Anntena test:
                  ]

    
    Dir.glob("*.log") { |f|
        @cnt = 0
        File.foreach(f){|line|
          str = line.split(" ")
          if line.match("OBW Center") then
            @obw_c = str[8].to_i
          elsif line.match("OBW Lower") then
            @obw_l = str[8].to_i
          elsif line.match("OBW Upper") then
            @obw_u = str[8].to_i
          elsif line.match("Frequency counter") then
            @freq = str[8].to_i
          elsif line.match("Result") then
            @ant_power = str[7].delete!("dBm")
#         elsif line.match("1   1") then
#           @spu1 = str[9].to_f
          elsif line.match("2   2") then
            @spu2 = str[9].to_f
          elsif line.match("3   3") then
            @spu3 = str[9].to_f
          elsif line.match("Upper: -") then
            @adj_u = str[7].delete!("dBm,")
            @adj_l = str[9].delete!("dBm")
          elsif line.match("INFO -- : -") then
            if @cnt == 0 then
                @mask1_l = str[6].to_f
                @mask1_u = str[9].to_f
                @cnt=1
                next
            elsif @cnt == 1 then
                @mask2_l = str[6].to_f
                @mask2_u = str[9].to_f
                @cnt=0
            end
          end
        }
        csvfile.puts [f,
                      "",
                      @obw_c,
                      "","", #@obw_l,@obw_u,
                      @freq,@ant_power,@spu1,@spu2,@spu3,
                      @adj_u,@adj_l,"",
#                     @mask1_l,@mask1_u,@mask2_l,@mask2_u
                     ]
    }
    csvfile.close
end

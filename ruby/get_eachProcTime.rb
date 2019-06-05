#!/usr/bin/ruby
require 'time'
require "csv"

#
# cd log-directry
# % ruby C:\201-lazurite\MJ2001\software\ruby\get_procTimeAll.rb

LOTS_NUM = 4 # 3月分は02周波数偏差、10エミッションマスクあり、4月はなし

START   = "Logfile created"
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
    csvfile = CSV.open('procTime.csv','w')

    if LOTS_NUM == 3 then
        csvfile.puts ["Calibration Summary:",
                      "01 Tolerance of occupied bandwidth:",
                      "02 Tolerance of frequency:",
                      "03 Antenna power pointn:",
                      "06 Tolerance of spurious:",
                      "07 Tolerance off adjacent channel leakage:",
                      "09 Career sense:",
                      "10 Spectrum emission mask:",
                      "Anntena test:",
                      "Total:"
                      ]
    else
        csvfile.puts ["Calibration Summary:",
                      "01 Tolerance of occupied bandwidth:",
                      "03 Antenna power pointn:",
                      "06 Tolerance of spurious:",
                      "07 Tolerance off adjacent channel leakage:",
                      "09 Career sense:",
                      "Anntena test:",
                      "Total:"
                      ]
    end

    Dir.glob("*.log") { |f| p f
        @t_start = 0
        @t_calib = 0
        @t_obw   = 0
        @t_freq  = 0
        @t_power = 0
        @t_spurious = 0
        @t_adjacent = 0
        @t_cca   = 0
        @t_mask  = 0
        @t_anntena  = 0
        @t_finish   = 0

        File.foreach(f){|line|
          if line.match(START) then
            str = line.split(" ")
            @t_start = Time.parse(str[5])
          elsif line.match(CALIB) then
            @t_calib = Time.parse(line[15,8])
          elsif line.match(OBW) then
            @t_obw = Time.parse(line[15,8])
          elsif line.match(FREQ) then           #LOTS_NUM=3
            @t_freq = Time.parse(line[15,8])    #LOTS_NUM=3
          elsif line.match(POWER) then
            @t_power = Time.parse(line[15,8])
          elsif line.match(SPURIOUS) then
            @t_spurious = Time.parse(line[15,8])
          elsif line.match(ADJACENT) then
            @t_adjacent = Time.parse(line[15,8])
          elsif line.match(CCA) then
            @t_cca = Time.parse(line[15,8])
          elsif line.match(MASK) then           #LOTS_NUM=3
            @t_mask = Time.parse(line[15,8])    #LOTS_NUM=3
          elsif line.match(ANNTENA) then
            @t_anntena = Time.parse(line[15,8])
          elsif line.match(FINISH) then
            @t_finish = Time.parse(line[15,8])
          end
        }

        if LOTS_NUM == 3 then
            if @t_start == 0 || @t_calib == 0 || @t_obw == 0 ||
               @t_freq == 0 || @t_mask == 0 ||
               @t_power == 0 || @t_spurious == 0 || @t_adjacent == 0 || 
               @t_cca == 0 || @t_anntena == 0 || @t_finish == 0 then
               next
            end
        else
            if @t_start == 0 || @t_calib == 0 || @t_obw == 0 ||
               @t_power == 0 || @t_spurious == 0 || @t_adjacent == 0 || 
               @t_cca == 0 || @t_anntena == 0 || @t_finish == 0 then
               next
            end
        end

        tt_calib    = @t_calib.to_time.to_i - @t_start.to_time.to_i
        tt_obw      = @t_obw.to_time.to_i - @t_calib.to_time.to_i
        if LOTS_NUM == 3 then
            tt_freq     = @t_freq.to_time.to_i - @t_obw.to_time.to_i
            tt_power    = @t_power.to_time.to_i - @t_freq.to_time.to_i
        else
            tt_power    = @t_power.to_time.to_i - @t_obw.to_time.to_i
        end
        tt_spurious = @t_spurious.to_time.to_i - @t_power.to_time.to_i
        tt_adjacent = @t_adjacent.to_time.to_i - @t_spurious.to_time.to_i
        tt_cca      = @t_cca.to_time.to_i - @t_adjacent.to_time.to_i
        if LOTS_NUM == 3 then
            tt_mask     = @t_mask.to_time.to_i - @t_cca.to_time.to_i
            tt_anntena  = @t_anntena.to_time.to_i - @t_mask.to_time.to_i
        else
            tt_anntena  = @t_anntena.to_time.to_i - @t_cca.to_time.to_i
        end
        tt_finish   = @t_finish.to_time.to_i - @t_start.to_time.to_i

        if LOTS_NUM == 3 then
           csvfile.puts [tt_calib,tt_obw,tt_freq,tt_power,tt_spurious,tt_adjacent,tt_cca,tt_mask,tt_anntena,tt_finish]
        else
            csvfile.puts [tt_calib,tt_obw,tt_power,tt_spurious,tt_adjacent,tt_cca,tt_anntena,tt_finish]
        end
        printf("======================================================================\n")
        printf("%s: %d\n",CALIB, tt_calib)
        printf("%s: %d\n",OBW, tt_obw)
        if LOTS_NUM == 3 then
            printf("%s: %d\n",FREQ, tt_freq)
        end
        printf("%s: %d\n",POWER, tt_power)
        printf("%s: %d\n",SPURIOUS, tt_spurious)
        printf("%s: %d\n",ADJACENT, tt_adjacent)
        printf("%s: %d\n",CCA, tt_cca)
        if LOTS_NUM == 3 then
            printf("%s: %d\n",MASK, tt_mask)
        end
        printf("%s: %d\n",ANNTENA, tt_anntena)
        printf("%s: %d\n",FINISH, tt_finish)
    }

    csvfile.close
end

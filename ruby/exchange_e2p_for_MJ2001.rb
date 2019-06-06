#! /usr/bin/ruby

require 'rubygems'
require 'serialport'
require 'timeout'

print("input COM number => ")
com = gets().to_i
#com = "42"
com = "COM" + com.to_s

$SERIAL_PORT =com
$SERIAL_BAUDRATE=115200


t = Time.now
date = sprintf("%04d%02d%02d%02d%02d_",t.year,t.mon,t.mday,t.hour,t.min)

sp = SerialPort.new($SERIAL_PORT,$SERIAL_BAUDRATE)
sp.read_timeout=500
sp.puts("sgi")
p sp.gets()
sp.puts("sgb, 24, 0xabcd, 100, 20")
p sp.gets()
sp.puts("erd, 0x20, 8")
p sp.gets()

sp.puts("erd, 0x20, 8")
val = sp.gets()
tmp = val.split(",")
mac_addr = sprintf("%X%X%X%X%X%X%X%X",tmp[3].to_i(16),tmp[4].to_i(16),tmp[5].to_i(16),
                   tmp[6].to_i(16),tmp[7].to_i(16),tmp[8].to_i(16),tmp[9].to_i(16),tmp[10].to_i(16))
p mac_addr
logfilename = "./exchange_e2p_log/" + date.to_s + "_" + mac_addr.to_s + ".log"
output = File.open(logfilename,"w")


sp.puts("erd, 0xa0, 1")
p sp.gets()
sp.puts("rfr 8 0x71 0x02")
p sp.gets()

print("change ? [y/n] :")
val = gets()
#val = "y"
if val.to_s =~ /y/ then
	sp.puts("ewp 0")
	p sp.gets()
	sp.puts("ewr, 0x24, 4")
	p sp.gets()
	sp.puts("ewr, 0xa0, 5")
	p sp.gets()
	sp.puts("ewp 1")
	p sp.gets()
	p "changed"
end

sp.puts("sgi")
p sp.gets()
sp.puts("sgb, 24, 0xabcd, 100, 20")
p sp.gets()
sp.puts("erd, 0x20, 8")
p sp.gets()
sp.puts("erd, 0xa0, 1")
p sp.gets()
sp.puts("rfr 8 0x71 0x02")
p sp.gets()

sp.puts("erd, 0x20, 16")
val = sp.gets()
output.puts val
p val
sp.puts("erd, 0x30, 16")
val = sp.gets()
output.puts val
p val
sp.puts("erd, 0x40, 16")
val = sp.gets()
output.puts val
p val
sp.puts("erd, 0x50, 16")
val = sp.gets()
output.puts val
p val
sp.puts("erd, 0x60, 16")
val = sp.gets()
output.puts val
p val
sp.puts("erd, 0x70, 16")
val = sp.gets()
output.puts val
p val
sp.puts("erd, 0x80, 16")
val = sp.gets()
output.puts val
p val
sp.puts("erd, 0x90, 16")
val = sp.gets()
output.puts val
p val
sp.puts("erd, 0xa0, 16")
val = sp.gets()
output.puts val
p val

sp.close

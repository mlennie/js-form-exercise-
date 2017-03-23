# What is the total amount in dollars of debits?
# What is the total amount in dollars of credits?
# How many autopays were started?
# How many autopays were ended?
# What is balance of user ID 2456938384156277127?

str = IO.read("./txnlog.dat").force_encoding("BINARY")
io = StringIO.new(str)
#print io
# parse header
magic_string = io.read(4)
version = io.read(1).unpack("c")[0]
num_of_records = io.read(4).unpack("N")[0]


#puts io.inspect
#parse records
(0...num_of_records).each do |record|
 type_enum = io.read(1)
 puts type_enum
 puts type_enum == "\x00"
 timestamp = io.read(4).unpack("N")[0]
 puts timestamp
 uid = io.read(8).unpack("q")[0]
 puts uid
 puts "YAYYYY!"

 #puts type_enum
 #puts type_enum == "/x00"
 #puts "YAYYYY!"
 break
 #puts io.read(4)
 #puts io.read(8).unpack("l")
 #puts "**********************************"
end

#io = File.open("./txnlog.dat",'rb')
#print io.bytes.to_a
#puts io.inspect
#puts '"' + io.each_byte.map { |b| '\x%02x' % b }.join + '"'
# print io.unpack("n")
#len = io.read(4) #.unpack("V")
#puts len.inspect
#version = io.read(1)
#puts version
#io.seek 2
#num_records = io.read(4)
#puts num_records

#name = io.read(len)
#puts name

# What is the total amount in dollars of debits?
# What is the total amount in dollars of credits?
# How many autopays were started?
# How many autopays were ended?
# What is balance of user ID 2456938384156277127?

str = IO.read("./txnlog.dat") #.force_encoding("BINARY")
io = StringIO.new(str)

total_debit_amount = 0.00000000000
total_credit_amount = 0.0000000000
autopays_started = 0
autopays_ended = 0
user_balance = 0.0000000000

# parse header
magic_string = io.read(4)
version = io.read(1).unpack("c")[0]
num_of_records = io.read(4).unpack("N")[0]

# parse records
(0...num_of_records).each do |record|
 type_enum = io.read(1)
 puts type_enum.unpack("c")[0]
 timestamp = io.read(4).unpack("N")[0]
 puts timestamp
 uid = io.read(8).unpack("Q")[0]
 puts uid
 puts "2456938384156277127"

 if type_enum == "\x00" || type_enum == "\x01"
   amount = io.read(8).unpack("G")[0]
   puts "amount"
   puts amount

   puts "Equals id 2456938384156277127?"
   if uid == 2456938384156277127
     user_balance += amount
     puts "YYYYYYYYYYYYYYEEEEEEEEEEEEEEEESSSSSSSSSSSSSSSSSSSS!!!!!!!!!!!!!!!"
   end
 end

 if type_enum == "\x00" # debit
   total_debit_amount += amount
 elsif type_enum == "\x01" # credit
   total_credit_amount += amount
 elsif type_enum == "\x02" # auto started
   autopays_started += 1
 elsif type_enum == "\x03" # auto ended
   autopays_ended += 1
 end

 puts "**********************************"
end

puts total_debit_amount
puts total_credit_amount
puts autopays_started
puts autopays_ended
puts user_balance

require_relative("functions/feat_trans_functions")

# Run login/signup
# main menu
#   add trans/recur
#       add trans
#       setup recur
#   search trans/balance
#       search by date/s
#           Edit/delete
#       search by category
#           Edit/delete
#   check zero bal
#       go to date
#           edit
#   delete account
#   logout

username = "test"

puts "Select an option"
puts "1 - Add single transaction"
puts "2 - Setup recurring transaction"
puts "3 - Search transaction by date"
opt = gets.chomp.to_i

if opt == 1
    add_single_trans(username)
elsif opt == 2
    add_recurring_trans(username)
elsif opt == 3
    search_trans_by_date(username)
else
    puts "You fucked up. I'm outta here!"
end

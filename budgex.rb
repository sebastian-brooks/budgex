require_relative("functions/add_transactions")
require_relative("functions/search_transactions")
require_relative("functions/get_balance")

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

puts "WELCOME TO BUDGEX - A BUDGET AND EXPENSE TRACKING TOOL"
puts "Select an option"
puts "1 - Add single transaction"
puts "2 - Setup recurring transaction"
puts "3 - Search transaction by date"
puts "4 - Search transactions by date range"
puts "5 - Search transactions by category"
puts "6 - Search transactions by date range and category"
puts "7 - Get current balance"
puts "8 - Get future balance"
puts "9 - Check for sub-zero balance danger"

opt = gets.chomp.to_i

case opt
when 1
    add_single_trans(username)
when 2
    add_recurring_trans(username)
when 3
    search_trans_by_date(username)
when 4
    search_trans_by_date_range(username)
when 5
    search_trans_by_cat(username)
when 6
    search_trans_by_cat_date_range(username)
when 7
    get_balance(username)
when 8
    get_balance(username, 1)
when 9
    sub_zero_balance_check(username)
else
    puts "You fucked up. I'm outta here!"
end

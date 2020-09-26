require_relative("functions/add_transactions")
require_relative("functions/search_transactions")
require_relative("functions/get_balance")
require_relative("functions/user_signup")
require_relative("functions/user_login")
require_relative("functions/delete_user")
require_relative("functions/change_password")

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

username = nil

puts "WELCOME TO BUDGEX - A BUDGET AND EXPENSE TRACKING TOOL"
puts "1 - Login"
puts "2 - Signup"

opt = gets.chomp.to_i

case opt
when 1
    username = user_login
when 2
    username = user_signup
end

puts "Hi #{username}!"
puts "Select an option from the main menu:"
puts "1  - Add single transaction"
puts "2  - Setup recurring transaction"
puts "3  - Search transaction by date"
puts "4  - Search transactions by date range"
puts "5  - Search transactions by category"
puts "6  - Search transactions by date range and category"
puts "7  - Get current balance"
puts "8  - Get future balance"
puts "9  - Check for sub-zero balance danger"
puts "10 - Change password"
puts "11 - Delete Account"
puts "12 - Logout"

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
when 10
    change_pw(username)
when 11
    delete_user(username)
when 12
    puts "ok bye"
else
    puts "You fucked up. I'm outta here!"
end

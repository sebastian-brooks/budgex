require_relative("functions/add_transactions")
require_relative("functions/search_transactions")
require_relative("functions/get_balance")
require_relative("functions/user_signup")
require_relative("functions/user_login")
require_relative("functions/delete_user")
require_relative("functions/change_password")
require_relative("functions/edit_transaction")

username = nil
start = true
run = true

puts "WELCOME TO BUDGEX - A BUDGET AND EXPENSE TRACKING TOOL"

while start
    puts "\n1 - LOGIN"
    puts "2 - SIGNUP"
    puts "3 - EXIT"
    opt = gets.chomp.to_i
    case opt
    when 1
        username = user_login
        start = false
    when 2
        username = user_signup
        start = false
    when 3
        puts "Thanks for stopping by!"
        start = false
        run = false
    else
        puts "Please only enter 1, 2 or 3"
    end
end

while run
    puts "Hi #{username}! What would you like to do?"
    puts "1 - ADD TRANSACTION"
    puts "2 - SEARCH TRANSACTIONS"
    puts "3 - CHECK BALANCE"
    puts "4 - DEBT CHECK"
    puts "5 - CHANGE PASSWORD"
    puts "6 - DELETE ACCOUNT"
    puts "7 - LOGOUT"

    opt = gets.chomp.to_i

    case opt
    when 1
        trans_add_opts(username)
    when 2
        trans_search_opts(username)
    when 3
        balance_opts(username)
    when 4
        sub_zero_balance_check(username)
    when 5
        change_pw(username)
    when 6
        delete_user(username)
        run = false
    when 7
        puts "Salame!"
        run = false
    else
        puts "They mostly come out at night. Mostly."
    end
end
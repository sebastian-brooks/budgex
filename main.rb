require_relative("functions/user_signup")
require_relative("functions/user_login")
require_relative("functions/add_transactions")
require_relative("functions/search_transactions")
require_relative("functions/edit_transaction")
require_relative("functions/get_balance")
require_relative("functions/change_password")
require_relative("functions/delete_user")

puts "WELCOME TO BUDGEX - A BUDGET AND EXPENSE TRACKING TOOL"

# Login/signup process
user = nil
while user.nil?
    puts "\n1 - SIGNUP"
    puts "2 - LOGIN"
    puts "3 - EXIT"
    opt = gets.chomp.to_i
    case opt
    when 1
        user = user_signup_process()
    when 2
        user = user_login_process()
    when 3
        puts "But I hardly knew you..."
        user = 1
        run = false
    else
        puts "Please only enter 1, 2 or 3"
    end
end

# Main program
logged_in = true
while logged_in
    puts "Hi #{user.username}! What would you like to do?"
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
        logged_in = false
    when 7
        puts "Salame!"
        logged_in = false
    else
        puts "They mostly come out at night. Mostly."
    end
end
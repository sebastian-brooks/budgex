require_relative("functions/user_signup")
require_relative("functions/user_login")
require_relative("functions/add_transaction")
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
        exit
    else
        puts "Please only enter 1, 2 or 3"
    end
end

# Main program navigation
while true
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
        add_transaction_process(user)
    when 2
        transaction_search_process(user)
    when 3
        check_balance_process(user)
    when 4
        sub_zero_balance_check(user)
    when 5
        change_password_process(user)
    when 6
        delete_user_process(user)
        puts "Don't forget to blink lest your eyeballs dry up, fall out of their sockets and dangle on your cheek like Caeser's shrivelled coglio"
        exit
    when 7
        puts "Thanks for stopping by, watch your back."
        exit
    else
        puts "That wasn't on the list of options, was it? Stick to the list."
    end
end
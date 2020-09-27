require("tty-prompt")
require_relative("functions/user_signup")
require_relative("functions/user_login")
require_relative("functions/add_transaction")
require_relative("functions/search_transactions")
require_relative("functions/edit_transaction")
require_relative("functions/get_balance")
require_relative("functions/change_password")
require_relative("functions/delete_user")

prompt = TTY::Prompt.new

puts "BUDGEX"
puts "budget & expense tracking made e z"

# Login/signup process
user = nil
while user.nil?
    choices = ["SIGNUP", "LOGIN", "EXIT"]
    opt = prompt.select("", choices)
    case opt
    when choices[0]
        user = user_signup_process()
    when choices[1]
        user = user_login_process()
    when choices[2]
        puts "But I hardly knew you..."
        exit
    else
        puts "Please only enter 1, 2 or 3"
    end
end

# Main program navigation
while true
    choices = [
        "ADD TRANSACTION",
        "SEARCH TRANSACTIONS",
        "CHECK BALANCE",
        "DEBT CHECK",
        "CHANGE PASSWORD",
        "DELETE ACCOUNT",
        "LOGOUT"
    ]
    opt = prompt.select("Hi #{user.username.upcase}! What would you like to do?", choices)
    case opt
    when choices[0]
        add_transaction_process(user)
    when choices[1]
        transaction_search_process(user)
    when choices[2]
        check_balance_process(user)
    when choices[3]
        sub_zero_balance_check(user)
    when choices[4]
        change_password_process(user)
    when choices[5]
        delete_user_process(user)
        puts "Don't forget to blink lest your eyeballs dry up, fall out of their sockets and dangle on your cheek like Caeser's shrivelled coglio"
        exit
    when choices[6]
        puts "Thanks for stopping by. Watch your back."
        exit
    end
end
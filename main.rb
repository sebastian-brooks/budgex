require("rainbow/refinement")
require("tty-font")
require("tty-prompt")
require_relative("functions/user_signup")
require_relative("functions/user_login")
require_relative("functions/add_transaction")
require_relative("functions/search_transactions")
require_relative("functions/edit_transaction")
require_relative("functions/get_balance")
require_relative("functions/change_password")
require_relative("functions/delete_user")
using Rainbow
system "clear"

font = TTY::Font.new(:starwars)
puts font.write(" --  BUDGEX  -- ").color(:green)

# Login/signup process
user = nil
while user.nil?
    choices = ["SIGNUP", "LOGIN", "EXIT"]
    opt = TTY::Prompt.new.select("Welcome to BUDGEX!", choices)
    case opt
    when choices[0]
        user = user_signup_process()
    when choices[1]
        user = user_login_process()
    when choices[2]
        puts "But I hardly knew you...".red.bright
        exit
    end
end

# Main program navigation
while true
    system "clear"
    puts font.write(" --  BUDGEX  -- ").color(:green)
    get_balance(user, 0, Date.today.to_s)
    choices = [
        "ADD TRANSACTION",
        "SEARCH TRANSACTIONS",
        "CHECK BALANCE/DEBT CHECK",
        "CHANGE PASSWORD",
        "DELETE ACCOUNT",
        "LOGOUT"
    ]
    opt = TTY::Prompt.new.select("\nHi #{user.username.upcase}! What would you like to do?\n".white.bright, choices)
    case opt
    when choices[0]
        add_transaction_process(user)
    when choices[1]
        transaction_search_process(user)
    when choices[2]
        check_balance_process(user)
    when choices[3]
        change_password_process(user)
    when choices[4]
        delete_user_process(user)
        puts "Don't forget to blink lest your eyeballs dry up, fall out of their sockets and dangle on your cheek like Caeser's shrivelled coglio".red
        exit
    when choices[5]
        puts "Thanks for stopping by. Watch your back.".color(:darksalmon)
        exit
    end
end
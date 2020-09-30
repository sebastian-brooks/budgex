require_relative("control/add_transaction")
require_relative("control/change_password")
require_relative("control/delete_user")
require_relative("control/edit_transaction")
require_relative("control/balance_checking")
require_relative("control/search_transactions")
require_relative("control/user_login")
require_relative("control/user_signup")
require_relative("functions/clear_screen_leave_logo")
require("rainbow/refinement")
require("tty-prompt")
require("tty-table")
using Rainbow

# Login/signup process
user = nil
while user.nil?
    clear_screen_print_logo()
    choices = ["SIGNUP", "LOGIN", "EXIT"]
    opt = TTY::Prompt.new.select("", choices)
    case opt
    when choices[0]
        user = user_signup_process()
    when choices[1]
        user = user_login_process()
    when choices[2]
        system "clear"
        puts "Well that was fun".color(:crimson)
        exit
    end
end

# Main program navigation/process
while true
    clear_screen_print_logo()
    balance = get_balance(user, 0, Date.today.to_s)[0]
    puts balance.render(:ascii)
    choices = [
        "ADD TRANSACTION",
        "SEARCH TRANSACTIONS",
        "FUTURE BALANCE/DEBT CHECK",
        "CHANGE PASSWORD",
        "DELETE ACCOUNT",
        "LOGOUT"
    ]
    opt = TTY::Prompt.new.select("\nHi #{user.username.upcase}! What would you like to do?\n".color(:cornflower), choices)
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
        system "clear"
        exit
    when choices[5]
        system "clear"
        puts "Thanks for stopping by. Watch your back.".color(:darksalmon)
        exit
    end
end

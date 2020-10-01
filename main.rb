require_relative("control/add_transaction")
require_relative("control/change_password")
require_relative("control/delete_user")
require_relative("control/edit_transaction")
require_relative("control/balance_checking")
require_relative("control/search_transactions")
require_relative("control/user_login")
require_relative("control/user_signup")
require_relative("methods/clear_screen_leave_logo")
require("optparse")
require("rainbow/refinement")
require("tty-prompt")
require("tty-table")
using Rainbow

@cli_options = {}
op = OptionParser.new do |opts|
    opts.on("-l", "--login", "provide valid username & password to open at main menu") do
        @cli_options[:login] = true
        @cli_options[:username] = ARGV[0]
        @cli_options[:password] = ARGV[1]
    end
    
    opts.on("-b", "--balance", "provide valid username & password to get quick balance") do
        @cli_options[:balance] = true
        @cli_options[:username] = ARGV[0]
        @cli_options[:password] = ARGV[1]
    end
end
op.parse!

user = nil

# Command line argument actions
if @cli_options[:login] == true
    user = User.new(@cli_options[:username], @cli_options[:password])
    confirmed = user.confirm_login_details()
    if confirmed != 1
        puts "Invalid login credentials".color(:crimson)
        exit
    end
elsif @cli_options[:balance] == true
    user = User.new(@cli_options[:username], @cli_options[:password])
    confirmed = user.confirm_login_details()
    system("clear")
    if confirmed == 1
        balance = get_balance(user)
        puts balance[0].render(:ascii)
        exit
    else
        puts "Invalid login credentials".color(:crimson)
        exit
    end
elsif ARGV.size >= 1
    puts "Invalid argument options".color(:crimson)
    exit
end

# Login/signup process
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
loop do
    clear_screen_print_logo()
    balance = get_balance(user)
    puts balance[0].render(:ascii)
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
        puts "Thanks for stopping by".color(:crimson)
        exit
    end
end

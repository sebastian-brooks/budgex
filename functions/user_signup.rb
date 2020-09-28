require_relative("../classes/user")
require_relative("check_user_in_users_list")
require_relative("clear_screen_leave_logo")
require_relative("get_amount")
require_relative("get_password")
require("rainbow/refinement")
using Rainbow

def create_username
    username = nil
    while username.nil?
        puts "ENTER A USERNAME"
        username = gets.chomp
        if username.count("a-zA-Z0-9") != username.length || username.empty? || username.match(" ") || ! username.length.between?(3,10)
            puts "\nNO. WRONG. BAD. ERROR. INVALID. USERNAME DOES NOT MEET CRITERIA.".red.bright.blink
            puts "\nUsername must consist of 3 to 10 alphanumeric characters with no symbols or spaces\n".color(:darkgray).italic
            username = nil
        end
        username = check_unique_user(username)
    end
    return username
end

# Check if username already exists in users.json
def check_unique_user(username)
    user_check = check_username_in_users(username)
    if user_check == 1
        puts "\nAh dang it! That username is already taken.\n".color(:orange)
        username = nil
    end
    return username
end

def create_password
    password = nil
    while password.nil?
        puts "ENTER A PASSWORD"
        puts "must consist of 8 to 16 characters with no spaces".color(:darkgray).italic
        password = get_password()
        if password.nil?
            puts "\nYOU DIDN'T EVEN ENTER ANYTHING. YOU THINK THIS IS A GAME???\n".red.bright
        elsif ! password.length.between?(8,16) || password.match(" ") || password.empty?
            puts "\nPASSWORD DOESN'T MEET CRITERIA. YOU'RE NOT EVEN TRYING.\n".red.bright
            password = nil
        end
    end
    return password
end

# Get starting balance from user input
def get_user_bal
    puts "ENTER YOUR CURRENT BANK ACCOUNT BALANCE"
    amount = get_amount()
    return amount
end

# Main - capture required details & instantiate a User class
def user_signup_process
    username = nil
    while username.nil?
        clear_screen_print_logo()
        username = create_username()
    end
    clear_screen_print_logo()
    password = create_password()
    new_user = User.new(username, password)
    new_user.add
    new_user.create_transactions_csv
    clear_screen_print_logo()
    user_balance = get_user_bal()
    new_user.create_balance_csv(user_balance)
    puts "\nSignup successful!".color(:salmon).bright
    sleep(1.5)
    return new_user
end
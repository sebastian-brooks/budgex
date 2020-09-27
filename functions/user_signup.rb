require_relative("../classes/user")
require_relative("get_password")
require_relative("check_user_in_users_list")
require_relative("get_amount")

# Create username from user input
def create_username
    username = nil
    while username.nil?
        puts "Enter a username consisting of 3 to 10 alphanumeric characters (no symbols or spaces)"
        username = gets.chomp
        if username.count("a-zA-Z0-9") != username.length || username.empty? || username.match(" ") || ! username.length.between?(3,10)
            puts "Nope, that's an invalid username"
            username = nil
        end
    end
    return username
end

# Check if username already exists in users.json
def check_unique_user(username)
    user_check = check_username_in_users(username)
    if user_check == 1
        puts "Dang, that username is already taken - try again"
        username = nil
    end
    return username
end

# Create password from user input
def create_password
    password = nil
    while password.nil?
        puts "Please create a password consisting of 8 to 16 characters with no spaces:"
        password = get_password()
        if ! password.length.between?(8,16) || password.match(" ") || password.empty?
            puts "Nope, that password doesn't meet the criteria"
            password = nil
        end
    end
    return password
end

# Get starting balance from user input
def get_user_bal
    puts "Please enter your current bank balance"
    amount = get_amount()
    return amount
end

# Main - capture required details & instantiate a User class
def user_signup_process
    username = nil
    while username.nil?
        username = create_username()
        username = check_unique_user(username)
    end
    password = create_password()
    new_user = User.new(username, password)
    new_user.add
    new_user.create_transactions_csv
    user_balance = get_user_bal()
    new_user.create_balance_csv(user_balance)
    puts "Signup successful!"
    return new_user
end
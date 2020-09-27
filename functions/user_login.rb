require_relative("../classes/user")
require_relative("get_password")
require_relative("check_user_in_users_list")

def get_username
    username = nil
    while username.nil?
        puts "Username:"
        username = gets.chomp
        username = nil if username.empty?
    end
    return username
end

def capture_password
    password = nil
    while password.nil?
        puts "Password:"
        password = get_password()
        password = nil if password.empty?
    end
    return password
end

def user_login_process
    login_attempts = 0
    user = nil
    while login_attempts <= 3 && user == nil
        login_attempts += 1
        username = get_username()
        password = capture_password()
        result = check_login_details(username, password)
        if result == 1
            user = User.new(username, password)
        end
    end
    puts "Too many login attempts - go away Julian Assange" if login_attempts > 3
    return user
end
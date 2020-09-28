require_relative("../classes/user")
require_relative("check_user_in_users_list")
require_relative("clear_screen_leave_logo")
require_relative("get_password")
require("rainbow/refinement")
using Rainbow

def get_username
    username = nil
    while username.nil?
        puts "USERNAME"
        username = gets.chomp
        if username.nil? || username.empty?
            puts "\nThis will work best if you actually provide a valid username".red.bright
            puts "\n"
            username = nil
        end
    end
    return username
end

def capture_password
    password = nil
    while password.nil?
        puts "PASSWORD:"
        password = get_password()
        if password.nil? || password.empty?
            puts "\nAmazing. Did you think that would work? Because it didn't.".red.bright
            puts "\n"
            password = nil
        end
    end
    return password
end

def user_login_process
    login_attempts = 0
    user = nil
    while login_attempts <= 3 && user == nil
        login_attempts += 1
        clear_screen_print_logo()
        username = get_username()
        clear_screen_print_logo()
        password = capture_password()
        result = check_login_details(username, password)
        if result == 1
            user = User.new(username, password)
        end
    end
    if login_attempts > 3
        puts "Too many login attempts - go away Julian Assange".color(:indigo)
        sleep(2)
    end
    return user
end
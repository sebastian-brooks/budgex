require_relative("clear_screen_leave_logo")
require("json")
require("rainbow/refinement")
using Rainbow

def username_capture
    username = ""
    while username.empty?
        puts "ENTER USERNAME:"
        username = gets.chomp
        if username.empty?
            clear_screen_print_logo()
            puts "\nNo username submitted - please enter a username\n".color(:orange).bright
        end
    end
    return username
end

def check_username_in_users_list(username)
    user_list = JSON.parse(File.read("user_files/users.json"))
    user_list["users"].each { |user|
        if user["username"] == username
            clear_screen_print_logo()
            puts "Ah dang it! That username is already taken, try another one\n".color(:orange).bright
            username = nil
        end
    }
    return username
end

def get_username(type=1)
    # type arg: 0 for initial username creation, 1 for standard username capture
    if type == 0
        username = nil
        while username.nil?
            username = username_capture()
            if username.count("a-zA-Z0-9") != username.length || username.match(" ") || ! username.length.between?(3,10)
                clear_screen_print_logo()
                puts "USERNAME DOES NOT MEET CRITERIA".red.bright
                puts "\nUsername must consist of 3 to 10 alphanumeric characters with no symbols or spaces\n".color(:darkgray).italic
                username = nil
            else
                username = check_username_in_users_list(username)
            end
        end
    else
        username = username_capture()
    end
    return username
end

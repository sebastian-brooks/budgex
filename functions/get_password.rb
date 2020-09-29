require_relative("clear_screen_leave_logo")
require("rainbow/refinement")
require("tty-prompt")
using Rainbow

def password_capture
    password = nil
    while password.nil?
        puts "ENTER PASSWORD:"
        password = TTY::Prompt.new.mask("")
        if password.nil?
            clear_screen_print_logo()
            puts "\nNo password submitted - please enter a password\n".color(:orange).bright
        end
    end
    return password
end

def get_password(type=1)
    # type arg: 0 for initial password creation, 1 for standard password capture
    if type == 0
        password = nil
        while password.nil?
            password = password_capture()
            if ! password.length.between?(8,16) || password.match(" ") || password.empty?
                clear_screen_print_logo()
                puts "PASSWORD DOES NOT MEET CRITERIA".red.bright
                puts "\nPassword must consist of 8 to 16 characters with no spaces\n".color(:darkgray).italic
                password = nil
            end
        end
    else
        password = password_capture()
    end
    return password
end

require_relative("../classes/user")
require_relative("clear_screen_leave_logo")
require_relative("get_password")
require("rainbow/refinement")
using Rainbow

def change_password_process(user)
    clear_screen_print_logo()
    puts "Sure, you can change your password (if you're into that sort of thing....weirdo)"
    puts "\nBut first please confirm your current password coz fraud 'n' that".cyan
    attempts = 0
    result = nil
    while attempts <= 3 && result.nil?
        attempts += 1
        puts "\nPASSWORD:"
        password = get_password()
        result = user.confirm_password(password)
    end
    if attempts > 3
        puts "\nToo many attempts - go away Sandra Bullock".color(:indigo)
        sleep(2)
    end
    if ! result.nil?
        clear_screen_print_logo()
        puts "OK, time to enter your new p-dub".cyan
        new_password = nil
        pw_strength = nil
        while new_password.nil?
            puts "\nNEW PASSWORD:"
            new_password = get_password()
            new_password = user.password_strength_check(new_password)
        end
        user.update_password(new_password)
        clear_screen_print_logo()
        puts "Password updated!\n".yellow
        sleep(2)
    end
end
require_relative("../classes/user")
require_relative("../methods/clear_screen_leave_logo")
require_relative("../methods/get_password")
require("rainbow/refinement")
using Rainbow

def change_password_process(user)
    clear_screen_print_logo()
    puts "Sure, you can change your password"
    puts "\nBut first, confirm your current password coz fraud 'n' that\n".color(:darkgray).italic
    attempts = 0
    result = nil
    while attempts < 3 && result.nil?
        attempts += 1
        password = get_password(1)
        result = user.confirm_password(password)
        clear_screen_print_logo()
    end
    if attempts >= 3
        puts "\nToo many attempts. You'd be a better lumberjack what with all this hacking".color(:indigo).bright
        sleep(3)
    end
    if ! result.nil?
        clear_screen_print_logo()
        puts "Time to enter your new password"
        puts "\n"
        new_password = get_password(0)
        user.update_password(new_password)
        puts "\nPassword updated!".color(:salmon)
        sleep(2)
    end
end
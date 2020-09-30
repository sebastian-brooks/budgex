require_relative("../classes/user")
require_relative("../methods/clear_screen_leave_logo")
require_relative("../methods/get_password")
require("json")
require("rainbow/refinement")
require("tty-prompt")
using Rainbow

def delete_user_process(user)
    clear_screen_print_logo()
    puts "If that's the way you want to be, just confirm your password and we'll delete your account"
    puts "\nWARNING - all of your data will be wiped. There won't be anything to remember you by\n".red.bright
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
        puts "Here we go. One last chance to avoid being wiped off the face of the earth...".color(:crimson)
        sleep(2)
        choices = ["NO", "YES"]
        opt = TTY::Prompt.new.select("\nStill want to delete your account?".color(:orange).bright, choices)
        if opt == choices[1]
            user.delete_user_files
            user.delete_user_login
            clear_screen_print_logo()
            puts "You don't appreciate anything. Good riddance.".color(:palevioletred).bright
            sleep(3)
        else
            clear_screen_print_logo()
            puts "I knew you'd come to your senses.".color(:palevioletred).bright
            sleep(3)
        end
    end
end
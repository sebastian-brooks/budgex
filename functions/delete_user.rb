require_relative("../classes/user")
require_relative("clear_screen_leave_logo")
require_relative("get_password")
require("json")
require("rainbow/refinement")
require("tty-prompt")
using Rainbow

def delete_user_process(user)
    clear_screen_print_logo()
    puts "If that's the way you want to be, just confirm your password and we'll delete your account".cyan
    puts "WARNING - all of your data will be wiped. There won't be anything to remember you by".red.bright
    attempts = 0
    result = nil
    while attempts <= 3 && result.nil?
        attempts += 1
        puts "\nPASSWORD:"
        password = get_password()
        result = user.confirm_password(password)
    end
    puts "\nToo many attempts - get out of here Edward Snowden".red.bright if attempts > 3
    if ! result.nil?
        clear_screen_print_logo()
        puts "Here we go. One last chance to stop us from deleting your entire history...".color(:orange)
        choices = ["YES", "NO"]
        opt = TTY::Prompt.new.select("\nStill want to delete your account?".color(:orange).bright, choices)
        if opt == choices[0]
            user.delete_user_files
            user.delete_user_login
            clear_screen_print_logo()
            puts "You're the worst. You don't appreciate anything. Good riddance.".color(:palevioletred).bright
            sleep(10)
        else
            clear_screen_print_logo()
            puts "I knew you'd come to your senses. I'll keep my eyes on you from now on though...".color(:palevioletred).bright
            sleep(1.5)
        end
    end
end
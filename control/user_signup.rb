require_relative("../classes/user")
require_relative("../methods/clear_screen_leave_logo")
require_relative("../methods/get_amount")
require_relative("../methods/get_password")
require_relative("../methods/get_username")
require("rainbow/refinement")
using Rainbow

def user_signup_process
    clear_screen_print_logo()
    username = get_username(0)
    clear_screen_print_logo()
    password = get_password(0)
    new_user = User.new(username, password)
    new_user.add
    new_user.create_transactions_csv
    clear_screen_print_logo()
    user_balance = get_amount(0)
    new_user.create_balance_csv(user_balance)
    puts "\nSignup successful!".color(:salmon).bright
    sleep(1.5)
    return new_user
end
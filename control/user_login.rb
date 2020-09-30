require_relative("../classes/user")
require_relative("../methods/clear_screen_leave_logo")
require_relative("../methods/get_password")
require_relative("../methods/get_username")
require("rainbow/refinement")
using Rainbow

def user_login_process
    confirmed = nil
    user = nil
    while confirmed != 1
        clear_screen_print_logo()
        username = get_username(1)
        clear_screen_print_logo()
        password = get_password(1)
        user = User.new(username, password)
        confirmed = user.confirm_login_details()
    end
    return user
end
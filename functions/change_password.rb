require_relative("../classes/user")
require_relative("get_password")

def change_password_process(user)
    puts "Sure, you can change your password (if you're into that sort of thing)"
    puts "But first please confirm your current password coz fraud 'n' that"
    attempts = 0
    result = nil
    while attempts <= 3 && result.nil?
        attempts += 1
        puts "Password:"
        password = get_password()
        result = user.confirm_password(password)
    end
    puts "Too many attempts - go away Sandra Bullock" if attempts > 3
    if ! result.nil?
        puts "OK, time to enter your new p-dub" 
        new_password = nil
        pw_strength = nil
        while new_password.nil?
            puts "New password:"
            new_password = get_password()
            new_password = user.password_strength_check(new_password)
        end
        user.update_password(new_password)
    end
end
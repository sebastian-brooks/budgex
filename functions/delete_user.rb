require("json")
require_relative("../classes/user")
require_relative("get_password")

def delete_user_process(user)
    puts "I guess you don't care that you are a wasteful pig on top of being a financially irresponsible human"
    puts "But... if that's the way you want to be, just confirm your password and we'll delete your account"
    puts "WARNING - all your data will be wiped. We don't want anything to remember you by"
    attempts = 0
    result = nil
    while attempts <= 3 && result.nil?
        attempts += 1
        puts "Password:"
        password = get_password()
        result = user.confirm_password(password)
    end
    puts "Too many attempts - get out of here Edward Snowden" if attempts > 3
    if ! result.nil?
        puts "Here we go. One last chance to stop us from deleting your entire history..."
        puts "Still want to delete your account? YES or NO?"
        opt = gets.chomp
        if opt.downcase == "yes" || opt.downcase == "y"
            user.delete_user_files()
            user.delete_user_login()
            puts "You're the worst. You don't appreciate anything. Good riddance."
        else
            puts "I knew you'd come to your senses. I'll keep my eyes on you from now on though..."
        end
    end
end
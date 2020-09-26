require "json"
require_relative("user_login")

def delete_user_files(uname)
    File.delete("user_transactions/#{uname}.csv")
    File.delete("user_transactions/#{uname}_balance.csv")
end

def delete_user_login(uname)
    un = JSON.parse(File.read("users/users.json"))
    un["users"].delete_if { |i| i["username"] == uname }
    File.write("users/users.json", JSON.generate(un))
end

def check_valid_pw(uname, pw)
    result = nil
    users = JSON.parse(File.read("users/users.json"))
    users["users"].each { |i|
        if i["username"] == uname && i["password"] == pw
            result = 1
            puts "Ok, that's a match"
        elsif i["username"] == uname && i["password"] != pw
            puts "Wrong password, pal"
            result = nil
        end
    }
    return result
end

def delete_user(uname)
    puts "I guess you don't care that you are a wasteful pig on top of being a financially irresponsible human"
    puts "But, if that's the way you want to be, just confirm your password and we'll delete your account"
    puts "WARNING - all your data will be wiped. We don't want anything to remember you by"
    result = nil
    while result.nil?
        pw = get_password()
        result = check_valid_pw(uname, pw)
    end
    if result == 1
        puts "Here we go. One last chance to stop us from deleting your entire history..."
        puts "Still want to delete your account? YES or NO?"
        yn = gets.chomp
        if yn.downcase == "yes"
            delete_user_files(uname)
            delete_user_login(uname)
            puts "You're the worst. You don't appreciate anything. Good riddance."
        else
            puts "I knew you'd come to your senses. I'll keep my eyes on you from now on though..."
        end
    else
        puts "It's too hard. I give up."
    end
end
require "json"
require_relative("user_login")
require_relative("delete_user")
require_relative("delete_user")

def update_pw(uname, pw)
    un = JSON.parse(File.read("users/users.json"))
    un["users"].each { |i|
        if i["username"] == uname
            i["password"] = pw
        end
    }
    File.write("users/users.json", JSON.generate(un))
end

def change_pw(uname)
    puts "Yeah, we can change your password"
    puts "But first, please confirm your current password. coz fraud n that..."
    result = nil
    while result.nil?
        pw = get_password()
        result = check_valid_pw(uname, pw)
    end
    puts "OK, time to enter your new pee-dub"
    pw = create_password()
    update_pw(uname, pw)
    puts "Success!"
end
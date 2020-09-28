require("json")
require("rainbow/refinement")
using Rainbow

def check_username_in_users(username)
    result = 0
    user_list = JSON.parse(File.read("users/users.json"))
    user_list["users"].each { |user|
        if user["username"] == username
            result = 1
        end
    }
    return result
end

def check_login_details(username, password)
    result = nil
    user_list = JSON.parse(File.read("users/users.json"))
    user_list["users"].each { |user|
        if user["username"] == username && user["password"] == password
            result = 1
        elsif user["username"] == username && user["password"] != password
            result = 0
        end
    }
    if result.nil?
        puts "\nNope, those details couldn't be found".color(:orange).bright
        sleep(1.5)
    elsif result == 0
        puts "\nHmmm, the username and password you provided don't match. Are you a dirty fraudster?".color(:orange).bright
        sleep(2)
    end
    return result
end
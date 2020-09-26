require "highline/import"

def get_username
    username = nil
    while username.nil?
        puts "Please enter your username:"
        username = gets.chomp.downcase.gsub(" ", "")
        if username.count("a-z") == username.length && username != "" && username.length >= 3
            puts "Thanks #{username}"
        else
            puts "That is an invalid username"
            username = nil
        end
    end
    return username
end

def get_pw(prompt="Please enter your password:")
    ask(prompt) {|q| q.echo = "*"}
end

def get_password
    pw = nil
    while pw.nil?
        pw = get_pw()
        if ! pw.length.between?(8,16) || pw.match(" ") || pw.empty?
            puts "That's an invalid password - we wouldn't let you sign up with a password like that"
            pw = nil
        end
    end
    return pw
end

def check_login_details(uname, pw)
    result = nil
    users = JSON.parse(File.read("users/users.json"))
    users["users"].each { |i|
        if i["username"] == uname && i["password"] == pw
            result = 1
        elsif i["username"] == uname && i["password"] != pw
            result = 0
        end
    }
    if result.nil?
        puts "Sorry, those details couldn't be found"
    elsif result == 0
        puts "Username and password don't match"
    end
    return result
end

def user_login
    run = true
    while run
        un = get_username
        pw = get_password
        result = check_login_details(un, pw)
        if result == 1
            run = false
        end
    end
    return un
end
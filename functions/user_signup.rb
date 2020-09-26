require "highline/import"
require "json"
require_relative("../classes/user")

def create_username
    username = nil
    while username.nil?
        puts "Please enter a username consisting only of at least 3 alphabetic characters (e.g. jbloggs - no symbols, numers or spaces)"
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

def get_password(prompt="Please enter a password consisting of at 8-16 characters with no spaces:")
    ask(prompt) {|q| q.echo = "*"}
end

def create_password
    pw = nil
    while pw.nil?
        pw = get_password()
        if ! pw.length.between?(8,16) || pw.match(" ") || pw.empty?
            puts "Password doesn't meet criteria"
            pw = nil
        end
    end
    return pw
end

def check_unique_user(uname)
    usr = uname
    un = JSON.parse(File.read("users/users.json"))
    un["users"].each { |i|
        if i["username"] == uname
            usr = nil
        end
    }
    if usr.nil?
        puts "Sorry, that username is already taken"
    end
    return usr
end

def get_bal
    amt = nil
    while amt.nil?
        puts "Please enter your current bank balance"
        amt = gets.chomp
        if amt[0] == "$"
            amt = amt[1..-1]
        end
        begin
            Integer(amt)
        rescue
            begin
                Float(amt)
            rescue
                puts "That is an invalid amount"
                amt = nil
            end
        end
    end
    amt = amt.to_f
    return amt
end

def user_signup
    username = nil
    while username.nil?
        username = create_username
        username = check_unique_user(username)
    end
    password = create_password
    user = User.new(username, password)
    user.add
    user.create_user_csv
    bal = get_bal
    user.opening_balance(bal)
    puts "Thanks! Signup successful!"
    return username
end
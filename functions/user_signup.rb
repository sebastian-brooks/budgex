# require 'rubygems'
require "highline/import"
require "json"

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

def create_user(un, pw)
    user = {"username" => un, "password" => pw}
    data = JSON.parse(File.read("users/users.json"))
    data["users"] << user
    File.write("users/users.json", JSON.generate(data))
    puts "Thanks #{un}"
end

def user_signup
    username = nil
    while username.nil?
        username = create_username
        username = check_unique_user(username)
    end
    password = create_password
    create_user(username, password)
end
require("csv")
require("json")

class User
    attr_reader :username
    attr_writer :password

    def initialize(username, password)
        @username = username
        @password = password
    end

    def add
        new_user = {"username" => @username, "password" => @password}
        user_list = JSON.parse(File.read("users/users.json"))
        user_list["users"] << new_user
        File.write("users/users.json", JSON.generate(user_list))
    end

    def create_transactions_csv
        CSV.open("user_transactions/#{@username}.csv", "w") do |row|
            row << ["id", "date", "amount", "description", "category", "recur"]
        end
    end

    def create_balance_csv(balance)
        CSV.open("user_transactions/#{@username}_balance.csv", "w") do |row|
            row << ["date", "balance"]
            row << [Date.today.to_s, balance]
        end
    end

    def confirm_password(password)
        result = nil
        if password == @password
            result = 1
        else
            puts "Hmmm, the password you provided is incorrect. Are you a dirty fraudster?"
        end
        return result
    end
    
    def password_strength_check(new_password)
        if ! new_password.length.between?(8,16) || new_password.match(" ") || new_password.empty?
            puts "Nope, that password doesn't meet the criteria"
            puts "Password must consist of 8 to 16 characters with no spaces"
            new_password = nil
        end
        return new_password
    end

    def update_password(new_password)
        user_list = JSON.parse(File.read("users/users.json"))
        user_list["users"].each { |user|
            if user["username"] == @username
                user["password"] = new_password
                @password = new_password
            end
        }
        File.write("users/users.json", JSON.generate(user_list))
        puts "Password successfully updated"
    end

    def delete_user_files
        File.delete("user_transactions/#{@username}.csv")
        File.delete("user_transactions/#{@username}_balance.csv")
    end
    
    def delete_user_login
        user_list = JSON.parse(File.read("users/users.json"))
        user_list["users"].delete_if { |user| user["username"] == @username }
        File.write("users/users.json", JSON.generate(user_list))
    end
end
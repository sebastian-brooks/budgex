require("csv")
require("json")
require("rainbow/refinement")
using Rainbow

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
        CSV.open("user_transactions/#{@username}_transactions.csv", "w") do |row|
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
            puts "\nHmmm, the password you provided is incorrect. Are you a dirty fraudster?".red.bright
        end
        return result
    end
    
    def password_strength_check(new_password)
        if new_password.nil? || ! new_password.length.between?(8,16) || new_password.match(" ") || new_password.empty?
            puts "\nNope, that password doesn't meet the criteria".red
            puts "\nPassword must consist of 8 to 16 characters with no spaces".color(:orange)
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
    end

    def sort_transactions
        transactions = CSV.read("user_transactions/#{@username}_transactions.csv", headers: true)
        transactions = transactions.sort { |a, b| a[1] <=> b[1] }
        CSV.open("user_transactions/#{@username}_transactions.csv", "w") do |row|
            row << ["id", "date", "amount", "description", "category", "recur"]
            transactions.each { |transaction| row << transaction }
        end
    end

    def generate_new_transaction_id
        id = []
        CSV.foreach("user_transactions/#{@username}_transactions.csv", headers: true) { |row| id << row["id"].to_i }
        if id.size == 0
            id << 0
        end
        return id.max + 1
    end

    def delete_user_files
        File.delete("user_transactions/#{@username}_transactions.csv")
        File.delete("user_transactions/#{@username}_balance.csv")
    end
    
    def delete_user_login
        user_list = JSON.parse(File.read("users/users.json"))
        user_list["users"].delete_if { |user| user["username"] == @username }
        File.write("users/users.json", JSON.generate(user_list))
    end
end
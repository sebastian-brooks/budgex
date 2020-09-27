require "csv"

class User
    attr_reader :username

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
end
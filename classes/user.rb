require "csv"

class User
    def initialize(username, password)
        @username = username
        @password = password
    end

    def add
        user = {"username" => @username, "password" => @password}
        data = JSON.parse(File.read("users/users.json"))
        data["users"] << user
        File.write("users/users.json", JSON.generate(data))
    end

    def create_user_csv
        CSV.open("user_transactions/#{@username}.csv", "w") do |row|
            row << ["id", "date", "amount", "description", "category", "recur"]
        end
    end

    def opening_balance(bal)
        bal_date = [Date.today.to_s, bal]
        CSV.open("user_transactions/#{@username}_transactions.csv", "w") do |row|
            row << ["date", "balance"]
            row << bal_date
        end
    end
end
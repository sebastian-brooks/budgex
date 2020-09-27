require("csv")

class Transaction
    attr_accessor :id, :date, :amount, :description, :category, :recur
    def initialize(username, id, date, amount, description, category, recur=0)
        @username = username
        @id = id
        @date = date
        @amount = amount
        @description = description
        @category = category
        @recur = recur
        @transaction = {id: @id, date: @date, amount: @amount, description: @description, category: @category, recur: @recur}
    end

    def add
        CSV.open("user_transactions/#{@username}_transactions.csv", "a") do |row|
            row << @transaction.values.to_a
        end
        puts "Transaction added"
    end
end
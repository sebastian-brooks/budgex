require("csv")

class Transaction
    attr_accessor :id, :date, :amount, :description, :category, :recur, :transaction
    def initialize(username, id, date, amount, description, category, recur = 0)
        @username = username
        @id = id
        @date = date
        @amount = amount
        @description = description
        @category = category
        @recur = recur
        @transaction = {
            id: @id,
            date: @date,
            amount: @amount,
            description: @description,
            category: @category,
            recur: @recur
        }
    end

    def add
        CSV.open("user_files/#{@username}_transactions.csv", "a") { |row|
            row << @transaction.values.to_a
        }
    end
end
require "csv"

class Transaction
    attr_reader :user, :id, :date, :amount, :description, :category
    def initialize(user, id, date, amount, description, category, recur=0)
        @user = user
        @id = id
        @date = date
        @amount = amount
        @description = description
        @category = category
        @recur = recur
        @trans = {id: @id, date: @date, amount: @amount, description: @description, category: @category, recur: @recur}
    end

    def add
        CSV.open("user_transactions/#{@user}.csv", "a") do |row|
            row << @trans.values.to_a
        end
        puts "Transaction added"
    end
end
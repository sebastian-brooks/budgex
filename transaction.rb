require "csv"

class Transaction
    def initialize(user, id, date, amount, description="", category="general", recur=0)
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
        CSV.open("#{@user}.csv", "a") do |row|
            row << @trans.values.to_a
        end
    end
end

def get_id(user)
    file = CSV.parse(File.read("#{user}.csv"))
    new_id = file.size + 1
end

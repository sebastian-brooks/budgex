require "csv"
require "date"

class Transaction
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
        CSV.open("#{@user}.csv", "a") do |row|
            row << @trans.values.to_a
        end
    end
end

def get_id(user)
    file = CSV.parse(File.read("#{user}.csv"))
    new_id = file.size + 1
end

def get_trans_date
    date = nil
    while date.nil?
        puts "Please enter the transaction date [FORMAT: YYYY-MM-DD (e.g. Dec 31st 1995 = 1995-12-31)]"
        date = gets.chomp
        begin
            Date.iso8601(date)
        rescue ArgumentError
            date = nil
            puts "That date is not valid."
        end
    end
    if date.length < 10
        date = Date.strptime(date, "%y-%m-%d")
    end
    return date
end
t_date = get_trans_date
# t_amt = get_trans_amt
# t_desc = get_trans_desc
# t_cat = get_trans_cat
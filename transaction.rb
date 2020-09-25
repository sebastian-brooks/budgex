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

def get_trans_amt
    amt = nil
    pos_neg = nil
    opt = nil
    while opt.nil?
        puts "Is this income or an expense?"
        puts "1 - Expense"
        puts "2 - Income"
        opt = gets.chomp.to_i
        if opt != 1 && opt != 2
            opt = nil
            puts "Please only enter 1 or 2 as your selection"
        end
    end
    while amt.nil?
        puts "Please enter the amount of the transaction [FORMAT: number or decimal (e.g. $9.25 = 9.25)]"
        amt = gets.chomp
        if amt[0] == "$"
            amt = amt[1..-1]
        end
        begin
            Integer(amt)
        rescue
            begin
                Float(amt)
            rescue
                puts 'That is an invalid amount'
                amt = nil
            end
        end
    end
    amt = amt.to_f
    if opt == 1
        amt = -amt
    end
    return amt
end

def get_trans_desc
    desc = nil
    while desc.nil?
        puts "What was the transaction for?"
        desc = gets.chomp
        if desc == "" || desc.strip() == ""
            desc = nil
            puts "Please enter a description of the transaction"
        end
    end
    return desc
end

def get_trans_cat
    cat = nil
    cat_arr = ["1 - FOOD", "2 - TRAVEL", "3 - RENT/HOME LOAN", "4 - INCOME", "5 - UTILITIES", "6 - HOUSEHOLD", "7 - ENTERTAINMENT", "8 - TECHNOLOGY"]
    opt = nil
    while opt.nil?
        puts "Please enter a number for the category that best describes the transaction from the list below:"
        cat_arr.each { |i| puts i }
        opt = gets.chomp.to_i
        if ! opt.between?(1,8)
            puts "Invalid selection"
            opt = nil
        end
    end
    cat_arr.each { |i|
        if i[0].to_i == opt
            cat = i[4..-1]
        end
    }
    return cat
end


t_date = get_trans_date
t_amt = get_trans_amt
t_desc = get_trans_desc
t_cat = get_trans_cat
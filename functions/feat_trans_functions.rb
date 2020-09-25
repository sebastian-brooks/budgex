require "csv"
require "date"
require_relative("../classes/transaction.rb")
require_relative("../classes/recurring.rb")
require_relative("get_date")

def get_id(user)
    id = []
    CSV.foreach("user_transactions/#{user}.csv", headers: true) { |row| id << row["id"].to_i }
    if id.size == 0
        id << 0
    end
    return id.max + 1
end

def get_trans_date
    puts "Please enter the transaction date [FORMAT: YYYY-MM-DD (e.g. Dec 31st 1995 = 1995-12-31)]"
    puts "Leave blank to use today's date"
    date = get_date
end

def get_recur_start_date
    puts "Please enter the date you want the recurrence to start [FORMAT: YYYY-MM-DD (e.g. Dec 31st 1995 = 1995-12-31)]"
    puts "Leave blank to use today's date"
    date = get_date
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
        puts "What is the transaction for?"
        desc = gets.chomp
        if desc == "" || desc.strip() == ""
            desc = nil
            puts "Please enter a description of the transaction"
        end
    end
    return desc.gsub(",", "")
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

def get_interval
    puts "What interval will the transactions occur over?"
    interval = gets.chomp
    return :month
end

def get_freq
    puts "How frequently do you want this to recur? e,g, every month (enter 1), every 2 months (enter 2) etc?"
    freq = gets.chomp.to_i
    return freq
end

def get_recur_end_date
    puts "Enter a date when the recurrence will end [FORMAT: YYYY-MM-DD (e.g. Dec 31st 1995 = 1995-12-31)]"
    puts "Leave blank to set maximum (5 years)"
    date = get_date(1)
end

def search_trans_by_date(user)
    puts "Please enter a transaction date [FORMAT: YYYY-MM-DD (e.g. Dec 31st 1995 = 1995-12-31)]"
    puts "Leave blank for today's date"
    date = get_date
    CSV.foreach("user_transactions/#{user}.csv", headers: true).select { |row|
        if row["date"] == date
            puts "#{row["id"]} | #{row["date"]} | #{row["amount"]} | #{row["description"]} | #{row["category"]}"
        end
    }
end
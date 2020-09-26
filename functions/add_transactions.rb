require "csv"
require "date"
require_relative("../classes/transaction.rb")
require_relative("../classes/recurring.rb")
require_relative("get_date")
require_relative("sort_csv")

def get_id(user)
    id = []
    CSV.foreach("user_transactions/#{user}.csv", headers: true) { |row| id << row["id"].to_i }
    if id.size == 0
        id << 0
    end
    return id.max + 1
end

def get_trans_date
    date = nil
    while date.nil?
        puts "Please enter the transaction date [FORMAT: YYYY-MM-DD (e.g. Dec 31st 1995 = 1995-12-31)]"
        puts "Leave blank to use today's date"
        date = get_date
    end
    return date
end

def get_recur_start_date
    date = nil
    while date.nil?
        puts "Please enter the date you want the recurrence to start [FORMAT: YYYY-MM-DD (e.g. Dec 31st 1995 = 1995-12-31)]"
        puts "Leave blank to use today's date"
        date = get_date
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
                puts "That is an invalid amount"
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
    ivls = ["1 - Week", "2 - Month", "3 - Year"]
    interval = nil
    puts "What interval will the transactions occur over?"
    while interval.nil?
        ivls.each { |i| puts i }
        puts "Enter the number for the recurrence intervals"
        interval = gets.chomp
        case interval[0].to_i
        when 1
            interval = :week
        when 2
            interval = :month
        when 3
            interval = :year
        else
            puts "That is not a valid selection - please only enter a number between 1 and 3"
            interval = nil
        end
    end
    return interval
end

def get_freq
    freq = nil
    while freq.nil?
        puts "How frequently do you want this to recur? e.g. every month/week/year (enter 1), every 2 weeks/months/years (enter 2) etc"
        freq = gets.chomp
        if freq == "0"
            freq = ""
        end
        begin
            freq.empty?
        rescue
            puts "That is an invalid frequency - please enter a whole number greater than 0"
            freq = nil
        end
        begin
            Integer(freq)
        rescue
            puts "That is an invalid frequency - please enter a whole number greater than 0"
            freq = nil
        end
    end
    return freq.to_i
end

def get_recur_end_date
    date = nil
    while date.nil?
        puts "Enter a date when the recurrence will end [FORMAT: YYYY-MM-DD (e.g. Dec 31st 1995 = 1995-12-31)]"
        puts "Leave blank to set maximum (5 years)"
        date = get_date(1)
    end
    return date
end

def add_single_trans(username)
    id = get_id(username)
    t_date = get_trans_date
    t_amt = get_trans_amt
    t_desc = get_trans_desc
    t_cat = get_trans_cat
    new_trans = Transaction.new(username, id, t_date, t_amt, t_desc, t_cat)
    new_trans.add
    sort_csv(username)
end

def add_recurring_trans(username)
    id = get_id(username)
    t_date = get_recur_start_date
    t_amt = get_trans_amt
    t_desc = get_trans_desc
    t_cat = get_trans_cat
    t_int = get_interval
    t_freq = get_freq
    t_end = get_recur_end_date
    new_trans = Recurring.new(username, id, t_date, t_amt, t_desc, t_cat, 1, t_int, t_freq, t_end)
    new_trans.add
    sort_csv(username)
end
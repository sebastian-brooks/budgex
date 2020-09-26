require "csv"
require_relative("get_date")

def retrieve_stored_balance(user)
    bal = {}
    CSV.foreach("user_transactions/#{user}_balance.csv", headers: true).select { |row|
        bal[:date] = row["date"]
        bal[:balance] = row["balance"].to_f
    }
    return bal
end

def get_balance(user, fut=0, date=nil)
    if fut == 1 && date.nil?
        while date.nil?
            puts "Please enter the future date you'd like to get your balance for [FORMAT: YYYY-MM-DD (e.g. Dec 31st 1995 = 1995-12-31)]"
            puts "Leave blank for today's date"
            date = get_date
        end
    elsif fut == 0 && date.nil?
        date = Date.today.to_s
    end
    bal_date = retrieve_stored_balance(user)[:date]
    bal_amt = retrieve_stored_balance(user)[:balance]
    CSV.foreach("user_transactions/#{user}.csv", headers: true).select { |row|
        if row["date"] >= bal_date && row["date"] <= date
            bal_amt += row["amount"].to_f
        end
    }
    puts "Balance at #{date}: #{bal_amt.to_d}"
    return bal_amt
end

def sub_zero_balance_check(user)
    curr_bal = get_balance(user)
    date = Date.today.to_s
    sub_z = nil
    scary_dates = []
    CSV.foreach("user_transactions/#{user}.csv", headers: true).select { |row|
        if row["date"] >= date
            curr_bal += row["amount"].to_f
            if curr_bal < 0
                sub_z = row["date"]
                scary_dates << row["date"]
            end
        end
    }
    if scary_dates.size == 0
        puts "Great news! You should have enough funds for all your scheduled expenses! Keep up the great work!"
    else
        puts "Awr crabshit! You won't have enough money on #{scary_dates.sort[0]}!"
    end
end

def balance_opts(uname)
    run = true
    while run
        puts "1 - GET CURRENT BALANCE"
        puts "2 - GET FUTURE BALANCE"
        puts "3 - RETURN TO MAIN MENU"
        opt = gets.chomp.to_i
        if opt == 1
            get_balance(uname)
            run = false
        elsif opt == 2
            get_balance(uname, 1)
            run = false
        elsif opt == 3
            run = false
        else
            puts "Please enter a number between 1 and 3"
        end
    end
end
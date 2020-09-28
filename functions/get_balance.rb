require_relative("get_date")
require("csv")
require("rainbow/refinement")
require("tty-prompt")
require("tty-table")
using Rainbow

def retrieve_stored_balance(user)
    bal = {}
    CSV.foreach("user_transactions/#{user.username}_balance.csv", headers: true).select { |row|
        bal[:date] = row["date"]
        bal[:balance] = row["balance"].to_f
    }
    return bal
end

def get_balance(user, fut=0, date=nil)
    if fut == 1 && date.nil?
        while date.nil?
            puts "Please enter the future date you'd like to get your balance for \n[FORMAT: YYYY-MM-DD (e.g. Dec 31st 1995 = 1995-12-31)]"
            puts "Leave blank for today's date"
            date = get_date()
        end
    elsif fut == 0 && date.nil?
        date = Date.today.to_s
    end
    bal_date = retrieve_stored_balance(user)[:date]
    bal_amt = retrieve_stored_balance(user)[:balance]
    CSV.foreach("user_transactions/#{user.username}_transactions.csv", headers: true).select { |row|
        if row["date"] >= bal_date && row["date"] <= date
            bal_amt += row["amount"].to_f
        end
    }
    case fut
    when 0
        table = TTY::Table.new(["  BALANCE  ".bright], [["  #{bal_amt.to_d}".color(:goldenrod)]])
    when 1
        table = TTY::Table.new(["  BALANCE AS OF #{date}  ".bright], [["  #{bal_amt.to_d}".color(:goldenrod)]])
    end
    puts table.render(:ascii)
    return bal_amt
end

def sub_zero_balance_check(user)
    curr_bal = get_balance(user)
    date = Date.today.to_s
    sub_z = nil
    scary_dates = []
    CSV.foreach("user_transactions/#{user.username}_transactions.csv", headers: true).select { |row|
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

def check_balance_process(user)
    run = true
    while run
        choices = ["GET FUTURE DATE BALANCE", "DEBT CHECK", "RETURN TO MAIN MENU"]
        opt = TTY::Prompt.new.select("", choices)
        case opt
        when choices[0]
            get_balance(user, 1)
            run = false
        when choices[1]
            sub_zero_balance_check(user)
            run = false
        when choices[2]
            run = false
        end
    end
end
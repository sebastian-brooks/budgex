require_relative("clear_screen_leave_logo")
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
            clear_screen_print_logo()
            puts "ENTER DATE TO CHECK BALANCE FOR"
            puts "FORMAT: YYYY-MM-DD e.g. Dec 31st 1995 = 1995-12-31".color(:darkgray).italic
            puts "Leave blank to use today's date".cyan.bright
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
    return [table, bal_amt]
end

def sub_zero_balance_check(user)
    curr_bal = get_balance(user)[1]
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
    clear_screen_print_logo()
    if scary_dates.size == 0
        puts "Great news! \n \nYou should have enough funds for all your scheduled expenses! \n \nKeep up the great work!".color(:lightgreen).bright
    else
        puts "OH SHIT!".color(:crimson).bright.underline.blink
        puts "\nYOU WON'T HAVE ENOUGH MONEY ON #{scary_dates.sort[0]}!".color(:crimson).bright
    end
    check_user_bal_preference(user)
end

def check_user_bal_preference(user)
    choices = ["CHECK AGAIN", "RETURN TO MAIN MENU"]
    opt = TTY::Prompt.new.select("", choices)
    check_balance_process(user) if opt == choices[0]
end

def check_balance_process(user)
    run = true
    while run
        clear_screen_print_logo()
        choices = ["CHECK BALANCE BY DATE", "FUTURE DEBT CHECK", "RETURN TO MAIN MENU"]
        opt = TTY::Prompt.new.select("", choices)
        case opt
        when choices[0]
            table = get_balance(user, 1)[0]
            clear_screen_print_logo()
            puts table.render(:ascii)
            check_user_bal_preference(user)
            run = false
        when choices[1]
            sub_zero_balance_check(user)
            run = false
        when choices[2]
            run = false
        end
    end
end
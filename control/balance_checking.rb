require_relative("../methods/clear_screen_leave_logo")
require_relative("../methods/get_date")
require("csv")
require("rainbow/refinement")
require("tty-prompt")
require("tty-table")
using Rainbow

def retrieve_stored_balance(user)
    balance = {}
    CSV.foreach("user_files/#{user.username}_balance.csv", headers: true).select { |row|
        balance[:date] = row["date"]
        balance[:amount] = row["balance"].to_f
    }
    return balance
end

def get_balance(user, type=0)
    # type arg: 0 = today's date, 1 = select a date
    if type == 0
        date = Date.today.to_s
    else
        date = get_date(1)
    end
    balance = retrieve_stored_balance(user)
    CSV.foreach("user_files/#{user.username}_transactions.csv", headers: true).select { |row|
        if row["date"] >= balance[:date] && row["date"] <= date
            balance[:amount] += row["amount"].to_f
        end
    }
    case type
    when 0
        table = TTY::Table.new(["  BALANCE  ".bright], [[" #{balance[:amount].to_f}".color(:crimson)]])
    when 1
        table = TTY::Table.new(["  Balance as of #{Date.parse(date).strftime("%b %d %Y")}  ".bright], [[" #{balance[:amount].to_f}".color(:crimson)]])
    end
    return [table, balance[:amount]]
end

def sub_zero_balance_check(user)
    curr_bal = get_balance(user)[1]
    date = Date.today.to_s
    sub_z = nil
    scary_dates = []
    CSV.foreach("user_files/#{user.username}_transactions.csv", headers: true).select { |row|
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
        puts "\nYOU MAY HAVE ENOUGH MONEY ON #{Date.parse(scary_dates.sort[0]).strftime("%b %d %Y")}!".color(:crimson).bright
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
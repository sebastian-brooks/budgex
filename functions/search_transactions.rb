require_relative("add_transaction")
require_relative("clear_screen_leave_logo")
require_relative("edit_transaction")
require_relative("get_balance")
require("csv")
require("rainbow/refinement")
require("tty-prompt")
require("tty-table")
using Rainbow

def search_transactions_by_date(user)
    search_date = nil
    while search_date.nil?
        puts "ENTER THE TRANSACTION DATE"
        puts "FORMAT: YYYY-MM-DD e.g. Dec 31st 1995 = 1995-12-31".color(:darkgray).italic
        puts "Leave blank to use today's date".cyan.bright
        search_date = get_date()
    end
    table = transaction_search(user, "date only", search_date)
    clear_screen_print_logo()
    if table.size == [0,0]
        puts "NO TRANSACTIONS FOUND\n".color(:orange)
    else
        puts "SEARCH RESULTS".color(:goldenrod).underline
        puts table.render(:ascii)
        get_balance(user, 0, search_date)
    end
    check_user_edit_preference(user, "date only", search_date)
end

def search_transactions_by_date_range(user)
    date_range = get_date_range(user)
    table = transaction_search(user, "date range", date_range[0], "", date_range[1])
    clear_screen_print_logo()
    if table.size == [0,0]
        puts "NO TRANSACTIONS FOUND\n".color(:orange)
    else
        puts "SEARCH RESULTS".color(:goldenrod).underline
        puts table.render(:ascii)
        get_balance(user, 0, date_range[1])
    end
    check_user_edit_preference(user, "date range")
end

def search_transactions_by_category(user)
    category = get_transaction_category()
    table = transaction_search(user, "cat only", "", category)
    clear_screen_print_logo()
    if table.size == [0,0]
        puts "NO TRANSACTIONS FOUND\n".color(:orange)
    else
        puts "SEARCH RESULTS".color(:goldenrod).underline
        puts table.render(:ascii)
    end
    check_user_edit_preference(user, "cat only")
end

def search_transactions_by_category_date_range(user)
    date_range = get_date_range(user)
    clear_screen_print_logo()
    category = get_transaction_category()
    table = transaction_search(user, "cat date range", date_range[0], category, date_range[1])
    clear_screen_print_logo()
    if table.size == [0,0]
        puts "NO TRANSACTIONS FOUND\n".color(:orange)
    else
        puts "SEARCH RESULTS".color(:goldenrod).underline
        puts table.render(:ascii)
        get_balance(user, 0, date_range[1])
    end
    check_user_edit_preference(user, "cat date range")
end

def check_user_edit_preference(user, type, date=nil)
    choices = ["EDIT/DELETE TRANSACTION", "SEARCH AGAIN", "RETURN TO MAIN MENU"]
    opt = TTY::Prompt.new.select("", choices)
    case opt
    when choices[0]
        edit_transaction_process(user, type, date)
    when choices[1]
        transaction_search_process(user)
    end
end

def get_date_range(user)
    start_date = nil
    while start_date.nil?
        puts "ENTER THE DATE RANGE START DATE"
        puts "FORMAT: YYYY-MM-DD e.g. Dec 31st 1995 = 1995-12-31".color(:darkgray).italic
        puts "Leave blank to use today's date".cyan.bright
        start_date = get_date
    end
    clear_screen_print_logo()
    end_date = nil
    while end_date.nil?
        puts "ENTER THE DATE RANGE END DATE"
        puts "FORMAT: YYYY-MM-DD e.g. Dec 31st 1995 = 1995-12-31".color(:darkgray).italic
        puts "Leave blank for the maximum date (5 years from today)".cyan.bright
        end_date = get_date(1)
    end
    return [start_date, end_date]
end

def transaction_search(user, type, date="", category="", range_end="")
    search_results = []
    CSV.foreach("user_transactions/#{user.username}_transactions.csv", headers: true).select { |row|
        if type == "date only" && row["date"] == date
            search_results << [row["id"], row["date"], row["amount"], row["description"], row["category"]]
        elsif type == "date range" && row["date"] >= date && row["date"] <= range_end
            search_results << [row["id"], row["date"], row["amount"], row["description"], row["category"]]
        elsif type == "cat only" && row["category"] == category
            search_results << [row["id"], row["date"], row["amount"], row["description"], row["category"]]
        elsif type == "cat date range" && row["category"] == category && row["date"] >= date && row["date"] <= range_end
            search_results << [row["id"], row["date"], row["amount"], row["description"], row["category"]]
        end
    }
    table = TTY::Table.new(["ID", "DATE", "AMOUNT", "DESCRIPTION", "CATEGORY"], search_results)
    return table
end

def transaction_search_process(user)
    run = true
    while run
        clear_screen_print_logo()
        choices = [
            "SEARCH TRANSACTIONS BY DATE",
            "SEARCH TRANSACTIONS BY DATE RANGE",
            "SEARCH TRANSACTIONS BY CATEGORY",
            "SEARCH TRANSACTIONS BY DATE RANGE & CATEGORY",
            "RETURN TO MAIN MENU"
        ]
        opt = TTY::Prompt.new.select("", choices)
        case opt
        when choices[0]
            clear_screen_print_logo()
            search_transactions_by_date(user)
            run = false
        when choices[1]
            clear_screen_print_logo()
            search_transactions_by_date_range(user)
            run = false
        when choices[2]
            clear_screen_print_logo()
            search_transactions_by_category(user)
            run = false
        when choices[3]
            clear_screen_print_logo()
            search_transactions_by_category_date_range(user)
            run = false
        when choices[4]
            run = false
        end
    end
end
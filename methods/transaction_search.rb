require_relative("clear_screen_leave_logo")
require_relative("get_date")
require_relative("get_transaction_category")
require("csv")
require("tty-prompt")
require("tty-table")

def transaction_search_results(user, type, date="", category="", range_end="")
    search_results = []
    CSV.foreach("user_files/#{user.username}_transactions.csv", headers: true).select { |row|
        transaction = [row["id"], row["date"], row["amount"], row["description"], row["category"]]
        if type == "date only" && row["date"] == date
            search_results << transaction
        elsif type == "date range" && row["date"] >= date && row["date"] <= range_end
            search_results << transaction
        elsif type == "cat only" && row["category"] == category
            search_results << transaction
        elsif type == "cat date range" && row["category"] == category && row["date"] >= date && row["date"] <= range_end
            search_results << transaction
        end
    }
    table = TTY::Table.new(["ID", "DATE", "AMOUNT", "DESCRIPTION", "CATEGORY"], search_results)
    return table
end

def search_transactions_by_date(user)
    choices = ["TODAY'S DATE", "ENTER A DIFFERENT DATE"]
    opt = TTY::Prompt.new.select("Select the date of the transaction\n", choices)
    if opt == choices[0]
        date = get_date(0)
    else
        date = get_date(1)
    end
    table = transaction_search_results(user, "date only", date)
    return table
end

def search_transactions_by_date_range(user)
    choices = ["TODAY'S DATE", "ENTER A DIFFERENT DATE"]
    opt = TTY::Prompt.new.select("Select the starting date of the search\n", choices)
    if opt == choices[0]
        start_date = get_date(0)
    else
        start_date = get_date(1)
    end
    clear_screen_print_logo()
    choices = ["SET MAXIMUM FUTURE DATE (5 YEARS FROM TODAY)", "ENTER A DIFFERENT DATE"]
    opt = TTY::Prompt.new.select("Select the end date of the recurring transaction\n", choices)
    if opt == choices[0]
        end_date = get_date(3)
    else
        end_date = get_date(1)
    end
    table = transaction_search_results(user, "date range", start_date, "", end_date)
    return table
end

def search_transactions_by_category(user)
    category = get_transaction_category()
    table = transaction_search_results(user, "cat only", "", category)
    return table
end

def search_transactions_by_category_date_range(user)
    choices = ["TODAY'S DATE", "ENTER A DIFFERENT DATE"]
    opt = TTY::Prompt.new.select("Select the starting date of the search\n", choices)
    if opt == choices[0]
        start_date = get_date(0)
    else
        start_date = get_date(1)
    end
    clear_screen_print_logo()
    choices = ["SET MAXIMUM FUTURE DATE (5 YEARS FROM TODAY)", "ENTER A DIFFERENT DATE"]
    opt = TTY::Prompt.new.select("Select the end date of the recurring transaction\n", choices)
    if opt == choices[0]
        end_date = get_date(3)
    else
        end_date = get_date(1)
    end
    clear_screen_print_logo()
    category = get_transaction_category()
    table = transaction_search_results(user, "cat date range", start_date, category, end_date)
    return table
end

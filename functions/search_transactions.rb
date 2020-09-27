require("csv")
require_relative("add_transaction")
require_relative("edit_transaction")
require_relative("get_balance")

def search_transactions_by_date(user)
    search_date = nil
    while search_date.nil?
        puts "Please enter a transaction date [FORMAT: YYYY-MM-DD (e.g. Dec 31st 1995 = 1995-12-31)]"
        puts "Leave blank for today's date"
        search_date = get_date()
    end
    CSV.foreach("user_transactions/#{user.username}_transactions.csv", headers: true).select { |row|
        if row["date"] == search_date
            puts "#{row["id"]} | #{row["date"]} | #{row["amount"]} | #{row["description"]} | #{row["category"]}"
        end
    }
    get_balance(user, 0, search_date)
    check_user_edit_preference(user)
end

def search_transactions_by_date_range(user)
    start_date = nil
    while start_date.nil?
        puts "Please enter the start date of the transaction date range [FORMAT: YYYY-MM-DD (e.g. Dec 31st 1995 = 1995-12-31)]"
        puts "Leave blank for today's date"
        start_date = get_date
    end
    end_date = nil
    while end_date.nil?
        puts puts "Please enter the end date of the transaction date range [FORMAT: YYYY-MM-DD (e.g. Dec 31st 1995 = 1995-12-31)]"
        puts "Leave blank for the maximum date (5 years from today)"
        end_date = get_date(1)
    end
    CSV.foreach("user_transactions/#{user.username}_transactions.csv", headers: true).select { |row|
        if row["date"] >= start_date && row["date"] <= end_date
            puts "#{row["id"]} | #{row["date"]} | #{row["amount"]} | #{row["description"]} | #{row["category"]}"
        end
    }
    get_balance(user, 0, end_date)
    check_user_edit_preference(user)
end

def search_transactions_by_category(user)
    category = get_transaction_category()
    CSV.foreach("user_transactions/#{user.username}_transactions.csv", headers: true).select { |row|
        if row["category"] == category
            puts "#{row["id"]} | #{row["date"]} | #{row["amount"]} | #{row["description"]} | #{row["category"]}"
        end
    }
    check_user_edit_preference(user)
end

def search_transactions_by_category_date_range(user)
    start_date = nil
    while start_date.nil?
        puts "Please enter the start date of the transaction date range [FORMAT: YYYY-MM-DD (e.g. Dec 31st 1995 = 1995-12-31)]"
        puts "Leave blank for today's date"
        start_date = get_date
    end
    end_date = nil
    while end_date.nil?
        puts puts "Please enter the end date of the transaction date range [FORMAT: YYYY-MM-DD (e.g. Dec 31st 1995 = 1995-12-31)]"
        puts "Leave blank for the maximum date (5 years from today)"
        end_date = get_date(1)
    end
    category = get_transaction_category()
    CSV.foreach("user_transactions/#{user.username}_transactions.csv", headers: true).select { |row|
        if row["category"] == category && row["date"] >= start_date && row["date"] <= end_date
            puts "#{row["id"]} | #{row["date"]} | #{row["amount"]} | #{row["description"]} | #{row["category"]}"
        end
    }
    get_balance(user, 0, end_date)
    check_user_edit_preference(user)
end

def check_user_edit_preference(user)
    puts "1 - EDIT/DELETE TRANSACTION"
    puts "2 - RETURN TO MAIN MENU"
    opt = gets.chomp.to_i
    edit_transaction_process(user) if opt == 1
end

def transaction_search_process(user)
    run = true
    while run
        puts "1 - SEARCH TRANSACTIONS BY DATE"
        puts "2 - SEARCH TRANSACTIONS BY DATE RANGE"
        puts "3 - SEARCH TRANSACTIONS BY CATEGORY"
        puts "4 - SEARCH TRANSACTIONS BY DATE RANGE & CATEGORY"
        puts "5 - RETURN TO MAIN MENU"
        opt = gets.chomp.to_i
        case opt
        when 1
            search_transactions_by_date(user)
            run = false
        when 2
            search_transactions_by_date_range(user)
            run = false
        when 3
            search_transactions_by_category(user)
            run = false
        when 4
            search_transactions_by_category_date_range(user)
            run = false
        when 5
            run = false
        else
            puts "Please enter a number between 1 and 5"
        end
    end
end
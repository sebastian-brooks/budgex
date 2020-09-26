require "csv"
require_relative("add_transactions")
require_relative("get_balance")
require_relative("edit_transaction")

def search_trans_by_date(user)
    date = nil
    while date.nil?
        puts "Please enter a transaction date [FORMAT: YYYY-MM-DD (e.g. Dec 31st 1995 = 1995-12-31)]"
        puts "Leave blank for today's date"
        date = get_date
    end
    CSV.foreach("user_transactions/#{user}.csv", headers: true).select { |row|
        if row["date"] == date
            puts "#{row["id"]} | #{row["date"]} | #{row["amount"]} | #{row["description"]} | #{row["category"]}"
        end
    }
    get_balance(user, 0, date)
    check_user_edit_pref(user)
end

def search_trans_by_date_range(user)
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
    CSV.foreach("user_transactions/#{user}.csv", headers: true).select { |row|
        if row["date"] >= start_date && row["date"] <= end_date
            puts "#{row["id"]} | #{row["date"]} | #{row["amount"]} | #{row["description"]} | #{row["category"]}"
        end
    }
    get_balance(user, 0, end_date)
    check_user_edit_pref(user)
end

def search_trans_by_cat(user)
    cat = get_trans_cat
    CSV.foreach("user_transactions/#{user}.csv", headers: true).select { |row|
        if row["category"] == cat
            puts "#{row["id"]} | #{row["date"]} | #{row["amount"]} | #{row["description"]} | #{row["category"]}"
        end
    }
    check_user_edit_pref(user)
end

def search_trans_by_cat_date_range(user)
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
    cat = get_trans_cat
    CSV.foreach("user_transactions/#{user}.csv", headers: true).select { |row|
        if row["category"] == cat && row["date"] >= start_date && row["date"] <= end_date
            puts "#{row["id"]} | #{row["date"]} | #{row["amount"]} | #{row["description"]} | #{row["category"]}"
        end
    }
    get_balance(user, 0, end_date)
    check_user_edit_pref(user)
end

def check_user_edit_pref(uname)
    puts "1 - Edit/delete transaction"
    puts "2 - Return to main menu"
    opt = gets.chomp.to_i
    if opt == 1
        edit_trans_guide(uname)
    end
end

def trans_search_opts(uname)
    run = true
    while run
        puts "1 - SEARCH TRANSACTIONS BY DATE"
        puts "2 - SEARCH TRANSACTIONS BY DATE RANGE"
        puts "3 - SEARCH TRANSACTIONS BY CATEGORY"
        puts "4 - SEARCH TRANSACTIONS BY DATE RANGE & CATEGORY"
        puts "5 - RETURN TO MAIN MENU"
        opt = gets.chomp.to_i
        if opt == 1
            search_trans_by_date(uname)
            run = false
        elsif opt == 2
            search_trans_by_date_range(uname)
            run = false
        elsif opt == 3
            search_trans_by_cat(uname)
            run = false
        elsif opt == 4
            search_trans_by_cat_date_range(uname)
            run = false
        elsif opt == 5
            run = false
        else
            puts "Please enter a number between 1 and 5"
        end
    end
end
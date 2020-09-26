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
end

def search_trans_by_cat(user)
    cat = get_trans_cat
    CSV.foreach("user_transactions/#{user}.csv", headers: true).select { |row|
        if row["category"] == cat
            puts "#{row["id"]} | #{row["date"]} | #{row["amount"]} | #{row["description"]} | #{row["category"]}"
        end
    }
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
end
require "csv"
require "date"
require_relative("get_date")

def search_trans_by_date(user)
    puts "Please enter a transaction date [FORMAT: YYYY-MM-DD (e.g. Dec 31st 1995 = 1995-12-31)]"
    puts "Leave blank for today's date"
    date = get_date
    CSV.foreach("user_transactions/#{user}.csv", headers: true).select { |row|
        if row["date"] == date
            puts "#{row["id"]} | #{row["date"]} | #{row["amount"]} | #{row["description"]} | #{row["category"]}"
        end
    }
end

def search_trans_by_date_range(user)
    puts "Please enter the start date of the transaction date range [FORMAT: YYYY-MM-DD (e.g. Dec 31st 1995 = 1995-12-31)]"
    puts "Leave blank for today's date"
    start_date = get_date
    puts puts "Please enter the end date of the transaction date range [FORMAT: YYYY-MM-DD (e.g. Dec 31st 1995 = 1995-12-31)]"
    puts "Leave blank for the maximum (5 years from today)"
    end_date = get_date(1)
    CSV.foreach("user_transactions/#{user}.csv", headers: true).select { |row|
        if row["date"] >= start_date && row["date"] <= end_date
            puts "#{row["id"]} | #{row["date"]} | #{row["amount"]} | #{row["description"]} | #{row["category"]}"
        end
    }
end
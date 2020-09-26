require "csv"

def sort_csv(user)
    data = CSV.read("user_transactions/#{user}.csv", headers: true)
    data = data.sort { |a, b| a[1] <=> b[1] }
    CSV.open("user_transactions/#{user}.csv", "w") do |row|
        row << ["id", "date", "amount", "description", "category", "recur"]
        data.each { |i| row << i }
    end
end
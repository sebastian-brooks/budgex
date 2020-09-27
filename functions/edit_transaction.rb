require("tty-prompt")
require_relative("add_transaction")

def get_transaction_by_id(user)
    transaction = nil
    while transaction.nil?
        id = gets.chomp
        data = CSV.read("user_transactions/#{user.username}_transactions.csv", headers: true)
        data.each { |row|
            if row["id"].to_s == id
                transaction = Transaction.new(user.username, id.to_i, row["date"], row["amount"].to_f, row["description"], row["category"], row["recur"].to_i)
            end
        }
        puts "That is not a valid ID" if transaction.nil?
    end
    return transaction
end

def delete_transaction_by_id(user, transaction)
    user_trans = CSV.read("user_transactions/#{user.username}_transactions.csv", headers: true)
    user_trans.delete_if { |row| row["id"].to_i == transaction.id.to_i }
    CSV.open("user_transactions/#{user.username}_transactions.csv", "w", headers: true) do |row|
        row << ["id", "date", "amount", "description", "category", "recur"]
        user_trans.each { |trans| row << trans }
    end
end

def delete_transaction_by_date_id(user, transaction)
    user_trans = CSV.read("user_transactions/#{user.username}_transactions.csv", headers: true)
    user_trans.delete_if { |row| row["id"].to_i == transaction.id.to_i && row["date"] == transaction.date }
    CSV.open("user_transactions/#{user.username}_transactions.csv", "w", headers: true) do |row|
        row << ["id", "date", "amount", "description", "category", "recur"]
        user_trans.each { |trans| row << trans }
    end
end

def edit_transaction_process(user)
    run = true
    while run
        choices = ["EDIT TRANSACTION", "DELETE TRANSACTION"]
        opt = TTY::Prompt.new.select("", choices)
        case opt
        when choices[0]
            puts "Please enter the ID of the transaction you would like to edit"
            transaction = get_transaction_by_id(user)
            if transaction.recur == 1
                choices = ["JUST THIS TRANSACTION", "EDIT ENTIRE SERIES"]
                opt = TTY::Prompt.new.select("This is part of a recurring transaction. Would you like to edit the entire series, or just this instance?", choices)
                case opt
                when choices[0]
                    delete_transaction_by_date_id(user, transaction)
                    add_single_transaction_process(user)
                    run = false
                when choices[1]
                    delete_transaction_by_id(user, transaction)
                    add_recurring_transaction_process(user)
                    run = false
                end
            elsif transaction.recur == 0
                delete_transaction_by_id(user, transaction)
                add_single_transaction_process(user)
                run = false
            end
        when choices[1]
            puts "Please enter the ID of the transaction you would like to delete"
            transaction = get_transaction_by_id(user)
            if transaction.recur == 1
                choices = ["JUST THIS TRANSACTION", "DELETE ENTIRE SERIES"]
                opt = TTY::Prompt.new.select("This is part of a recurring transaction. Would you like to delete the entire series, or just this instance?", choices)
                case opt
                when choices[0]
                    delete_transaction_by_date_id(user, transaction)
                    puts "Deletion successful"
                    run = false
                when choices[1]
                    delete_transaction_by_id(user, transaction)
                    puts "Deletion successful"
                    run = false
                end
            elsif transaction.recur == 0
                delete_transaction_by_id(user, transaction)
                puts "Deletion successful"
                run = false
            else
                puts "Something has gone wrong here...sorry"
            end
        end
    end
end
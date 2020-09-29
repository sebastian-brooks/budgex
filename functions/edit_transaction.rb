# require_relative("../classes/recurring")
# require_relative("../classes/transaction")
require_relative("add_transaction")
require_relative("clear_screen_leave_logo")
require("rainbow/refinement")
require("tty-prompt")
using Rainbow

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
        puts "INVALID ID".red.bright if transaction.nil?
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
            puts "\nENTER THE ID OF THE TRANSACTION YOU WANT TO EDIT"
            transaction = get_transaction_by_id(user)
            if transaction.recur == 1
                choices = ["JUST THIS TRANSACTION", "EDIT ENTIRE SERIES"]
                opt = TTY::Prompt.new.select("\nThis is part of a recurring transaction. \nWould you like to edit the entire series, or just this instance?".color(:orange), choices)
                case opt
                when choices[0]
                    puts transaction
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
                edit = true
                while edit
                    clear_screen_print_logo()
                    puts "ID:           #{transaction.id}"
                    puts "DATE:         #{transaction.date}"
                    puts "AMOUNT:       #{transaction.amount}"
                    puts "DESCRIPTION:  #{transaction.description}"
                    puts "CATEGORY:     #{transaction.category}"
                    choices = ["EDIT DATE", "EDIT AMOUNT", "EDIT DESCRIPTION", "EDIT CATEGORY", "EDIT ALL DETAILS", "EDITING COMPLETE"]
                    opt = TTY::Prompt.new.select("", choices)
                    case opt
                    when choices[0]
                        transaction.date = single_date()
                    when choices[1]
                        transaction.amount = get_transaction_amount()
                    when choices[2]
                        transaction.description = get_transaction_description()
                    when choices[3]
                        transaction.category = get_transaction_category()
                    when choices[4]
                        add_single_transaction_process(user)
                        edit = false
                    when choices[5]
                        transaction.add()
                        user.sort_transactions
                        clear_screen_print_logo()
                        puts "Transaction edited!".color(:orange)
                        sleep(2)
                        edit = false
                    end
                end
                run = false
            end
        when choices[1]
            puts "\nENTER THE ID OF THE TRANSACTION YOU WANT TO DELETE"
            transaction = get_transaction_by_id(user)
            if transaction.recur == 1
                choices = ["JUST THIS TRANSACTION", "DELETE ENTIRE SERIES"]
                opt = TTY::Prompt.new.select("\nThis is part of a recurring transaction. \nWould you like to delete the entire series, or just this instance?".color(:orange), choices)
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
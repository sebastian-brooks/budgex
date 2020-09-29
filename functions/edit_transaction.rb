require_relative("../classes/recurring")
require_relative("../classes/transaction")
require_relative("add_transaction")
require_relative("clear_screen_leave_logo")
require_relative("get_amount")
require_relative("get_date")
require("rainbow/refinement")
require("tty-prompt")
using Rainbow

def get_transaction_by_id_date(user, id, date)
    transaction = nil
    while transaction.nil?
        data = CSV.read("user_transactions/#{user.username}_transactions.csv", headers: true)
        data.each { |row|
            if row["id"].to_s == id && date.nil?
                transaction = Transaction.new(user.username, id.to_i, row["date"], row["amount"].to_f, row["description"], row["category"], row["recur"].to_i)
            elsif row["id"].to_s == id && row["date"] == date
                transaction = Transaction.new(user.username, id.to_i, row["date"], row["amount"].to_f, row["description"], row["category"], row["recur"].to_i)
            end
        }
        puts "\nINVALID ID\n".red.bright if transaction.nil?
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

def display_selected_transaction(transaction)
    clear_screen_print_logo()
    puts "CURRENTLY EDITING:".color(:crimson).underline
    puts "ID:           #{transaction.id}".bright
    puts "DATE:         #{transaction.date}"
    puts "AMOUNT:       #{transaction.amount}"
    puts "DESCRIPTION:  #{transaction.description}"
    puts "CATEGORY:     #{transaction.category}\n"
end

def edit_single_transaction(user, transaction)
    edit = true
    while edit
        display_selected_transaction(transaction)
        choices = ["EDIT DATE", "EDIT AMOUNT", "EDIT DESCRIPTION", "EDIT CATEGORY", "EDIT ALL DETAILS", "EDITING COMPLETE"]
        opt = TTY::Prompt.new.select("", choices)
        case opt
        when choices[0]
            transaction.date = single_date()
        when choices[1]
            transaction.amount = get_amount(1)
        when choices[2]
            transaction.description = get_transaction_description()
        when choices[3]
            transaction.category = get_transaction_category()
        when choices[4]
            add_single_transaction_process(user)
            edit = false
        when choices[5]
            transaction.transaction = {id: transaction.id, date: transaction.date, amount: transaction.amount, description: transaction.description, category: transaction.category, recur: 0}
            transaction.add()
            user.sort_transactions
            clear_screen_print_logo()
            puts "Transaction edited!".color(:orange)
            sleep(2)
            edit = false
        end
    end
end

def edit_transaction_process(user, type, date=nil)
    run = true
    while run
        choices = ["EDIT TRANSACTION", "DELETE TRANSACTION"]
        opt = TTY::Prompt.new.select("", choices)
        puts "\nENTER THE ID OF THE TRANSACTION YOU WANT TO EDIT"
        id = gets.chomp
        if type !=  "date only"
            puts "\nENTER THE DATE OF THE TRANSACTION YOU WANT TO EDIT"
            date = get_date()
        end
        transaction = get_transaction_by_id_date(user, id, date)
        case opt
        when choices[0]
            if transaction.recur == 0
                delete_transaction_by_id(user, transaction)
                edit_single_transaction(user, transaction)
                run = false
            elsif transaction.recur == 1
                display_selected_transaction(transaction)
                choices = ["JUST THIS TRANSACTION", "EDIT ENTIRE SERIES"]
                opt = TTY::Prompt.new.select("\nThis is part of a recurring transaction. \nWould you like to edit the entire series, or just this instance?".color(:orange), choices)
                case opt
                when choices[0]
                    delete_transaction_by_date_id(user, transaction)
                    edit_single_transaction(user, transaction)
                    run = false
                when choices[1]
                    delete_transaction_by_id(user, transaction)
                    add_recurring_transaction_process(user)
                    run = false
                end
            end
        when choices[1]
            display_selected_transaction(transaction)
            if transaction.recur == 0
                choices = ["NO! I MADE A BIG MISTAKE!", "YES - DELETE IT ALREADY!"]
                opt = TTY::Prompt.new.select("\nAre you sure you want to delete this transaction?".color(:orange), choices)
                case opt
                when choices[1]
                    delete_transaction_by_id(user, transaction)
                    puts "Deletion successful".color(:orange)
                    sleep(2)
                end
                run = false
            elsif transaction.recur == 1
                choices = ["JUST THIS TRANSACTION", "DELETE ENTIRE SERIES"]
                opt = TTY::Prompt.new.select("\nThis is part of a recurring transaction. \nWould you like to delete the entire series, or just this instance?".color(:orange), choices)
                case opt
                when choices[0]
                    choices = ["NO! I MADE A BIG MISTAKE!", "YES - DELETE IT ALREADY!"]
                    opt = TTY::Prompt.new.select("\nAre you sure you want to delete this transaction?".color(:orange), choices)
                    case opt
                    when choices[1]
                        delete_transaction_by_date_id(user, transaction)
                        puts "Deletion successful".color(:orange)
                        sleep(2)
                    end
                    run = false
                when choices[1]
                    choices = ["NO! I MADE A BIG MISTAKE!", "YES - DELETE IT ALREADY!"]
                    opt = TTY::Prompt.new.select("\nAre you sure you want to delete this transaction?".color(:orange), choices)
                    case opt
                    when choices[1]
                        delete_transaction_by_id(user, transaction)
                        puts "Deletion successful".color(:orange)
                        sleep(2)
                    end
                    run = false
                end
            else
                puts "Something has gone wrong here...sorry"
            end
        end
    end
end
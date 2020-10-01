require_relative("../classes/recurring")
require_relative("../classes/transaction")
require_relative("add_transaction")
require_relative("../methods/clear_screen_leave_logo")
require_relative("../methods/get_amount")
require_relative("../methods/get_date")
require_relative("../methods/get_transaction_category")
require_relative("../methods/get_transaction_desc")
require("rainbow/refinement")
require("tty-prompt")
using Rainbow

def get_transaction_by_id_date(user, id, date)
    transaction = nil
    data = CSV.read("user_files/#{user.username}_transactions.csv", headers: true)
    data.each { |row|
        if row["id"].to_s == id && date.nil?
            transaction = Transaction.new(
                user.username,
                id.to_i,
                row["date"],
                row["amount"].to_f,
                row["description"],
                row["category"],
                row["recur"].to_i
            )
        elsif row["id"].to_s == id && row["date"] == date
            transaction = Transaction.new(
                user.username,
                id.to_i,
                row["date"],
                row["amount"].to_f,
                row["description"],
                row["category"],
                row["recur"].to_i
            )
        end
    }
    puts "INVALID ID\n".red.bright if transaction.nil?

    return transaction
end

def delete_transaction(user, transaction, type = 1)
    # type arg: 0 = delete by id, 1 = delete by date & id
    user_trans = CSV.read("user_files/#{user.username}_transactions.csv", headers: true)

    case type
    when 0
        user_trans.delete_if { |row| row["id"].to_i == transaction.id.to_i }
    when 1
        user_trans.delete_if { |row|
            row["id"].to_i == transaction.id.to_i && row["date"] == transaction.date
        }
    end

    CSV.open("user_files/#{user.username}_transactions.csv", "w", headers: true) { |row|
        row << ["id", "date", "amount", "description", "category", "recur"]
        user_trans.each { |trans| row << trans }
    }
end

def display_selected_transaction(transaction)
    clear_screen_print_logo()
    puts "CURRENTLY EDITING:".color(:crimson).underline
    puts "ID:           #{transaction.id}"
    puts "DATE:         #{transaction.date}"
    puts "AMOUNT:       #{transaction.amount}"
    puts "DESCRIPTION:  #{transaction.description}"
    puts "CATEGORY:     #{transaction.category}\n"
end

def edit_single_transaction(user, transaction)
    edit = true
    while edit
        display_selected_transaction(transaction)
        choices = [
            "EDIT DATE",
            "EDIT AMOUNT",
            "EDIT DESCRIPTION",
            "EDIT CATEGORY",
            "EDIT ALL DETAILS",
            "EDITING COMPLETE"
        ]
        opt = TTY::Prompt.new.select("", choices)
        case opt
        when choices[0]
            transaction.date = get_date(2)
        when choices[1]
            transaction.amount = get_amount()
        when choices[2]
            transaction.description = get_transaction_description()
        when choices[3]
            transaction.category = get_transaction_category()
        when choices[4]
            add_single_transaction_process(user)
            edit = false
        when choices[5]
            transaction.transaction = {
                id: transaction.id,
                date: transaction.date,
                amount: transaction.amount,
                description: transaction.description,
                category: transaction.category,
                recur: 0
            }
            transaction.add()
            user.sort_transactions
            clear_screen_print_logo()
            puts "Transaction edited!".color(:orange)
            sleep(2)
            edit = false
        end
    end
end

def edit_transaction_process(user)
    run = true
    while run
        choices = ["EDIT TRANSACTION", "DELETE TRANSACTION"]
        opt = TTY::Prompt.new.select("", choices)
        transaction = nil
        while transaction.nil?
            puts "\nENTER THE ID OF THE TRANSACTION"
            id = gets.chomp
            puts "\nCONFIRM THE DATE OF THE TRANSACTION"
            date = get_date(1)
            transaction = get_transaction_by_id_date(user, id, date)
        end
        if transaction.recur == 0 && opt == choices[0] # edit single
            delete_transaction(user, transaction, 0)
            edit_single_transaction(user, transaction)
            run = false
        elsif transaction.recur == 0 && opt == choices[1] # delete single
            choices = ["NO! I MADE A BIG MISTAKE!", "YES - DELETE IT ALREADY!"]
            opt = TTY::Prompt.new.select("\nAre you sure you want to delete this transaction?".color(:orange), choices)
            case opt
            when choices[1]
                delete_transaction(user, transaction, 0)
                puts "Deletion successful".color(:orange)
                sleep(2)
            end
            run = false
        elsif transaction.recur == 1
            display_selected_transaction(transaction)
            recur_choice = ["THIS TRANSACTION", "ENTIRE SERIES"]
            recur_opt = TTY::Prompt.new.select("\nThis is part of a recurring series of transactions.\nShould this action affect the entire series, or just this instance?".color(:orange), recur_choice)
            if recur_opt == recur_choice[0] && opt == choices[0] # edit single instance of recurring
                delete_transaction(user, transaction, 1)
                edit_single_transaction(user, transaction)
                run = false
            elsif recur_opt == recur_choice[1] && opt == choices[0] # edit entire series of recurring
                delete_transaction(user, transaction, 0)
                puts "OK, time to set up the series again!"
                sleep(2)
                add_recurring_transaction_process(user)
                run = false
            elsif recur_opt == recur_choice[0] && opt == choices[1] # delete single instance of recurring
                choices = ["NO! I MADE A BIG MISTAKE!", "YES - DELETE IT ALREADY!"]
                opt = TTY::Prompt.new.select("\nAre you sure you want to delete this transaction?".color(:orange), choices)
                case opt
                when choices[1]
                    delete_transaction(user, transaction, 1)
                    puts "Deletion successful".color(:orange)
                    sleep(2)
                end
                run = false
            elsif recur_opt == recur_choice[1] && opt == choices[1] # delete entire series of recurring
                choices = ["NO! I MADE A BIG MISTAKE!", "YES - DELETE IT ALREADY!"]
                opt = TTY::Prompt.new.select("\nAre you sure you want to delete all transactions in this recurring series?".color(:orange), choices)
                case opt
                when choices[1]
                    delete_transaction(user, transaction, 0)
                    puts "Deletion successful".color(:orange)
                    sleep(2)
                end
                run = false
            end
        end
    end
end
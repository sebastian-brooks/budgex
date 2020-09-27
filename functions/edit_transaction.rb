require_relative("add_transaction")

def get_trans_by_id(un)
    result = nil
    recur = nil
    date = nil
    while result.nil?
        id = gets.chomp
        data = CSV.read("user_transactions/#{un}_transactions.csv", headers: true)
        data.each { |row|
            if row["id"].to_s == id
                result = 1
                recur = row["recur"].to_i
                date = row["date"]
            end
        }
        if result.nil?
            puts "That is not a valid ID"
        end
    end
    deets = [id, date, recur]
    return deets
end

def delete_trans_by_id(un, trans_id)
    csv = CSV.read("user_transactions/#{un}_transactions.csv", headers: true)
    csv.delete_if { |row| row["id"].to_s == trans_id }
    CSV.open("user_transactions/#{un}_transactions.csv", "w", headers: true) do |row|
        row << ["id", "date", "amount", "description", "category", "recur"]
        csv.each { |trans| row << trans }
    end
end

def delete_trans_by_date_id(un, date, trans_id)
    csv = CSV.read("user_transactions/#{un}_transactions.csv", headers: true)
    csv.delete_if { |row| row["id"].to_s == trans_id && row["date"] == date }
    CSV.open("user_transactions/#{un}_transactions.csv", "w", headers: true) do |row|
        row << ["id", "date", "amount", "description", "category", "recur"]
        csv.each { |trans| row << trans }
    end
end

def edit_transaction_process(user)
    run = true
    while run
        puts "What would you like to do?"
        puts "1 - Edit transaction"
        puts "2 - Delete transaction"
        opt = gets.chomp.to_i
        case opt
        when 1
            puts "Please enter the ID of the transaction you would like to edit"
            trans_details = get_trans_by_id(uname)
            if trans_details[2] == 1
                puts "This is part of a recurring transaction. Would you like to edit the entire series, or just this instance?"
                puts "1 - Just this transaction"
                puts "2 - Edit entire series"
                opt = gets.chomp.to_i
                case opt
                when 1
                    delete_trans_by_date_id(uname, trans_details[1], trans_details[0])
                    add_single_trans(uname)
                    run = false
                when 2
                    delete_trans_by_id(uname, trans_details[0])
                    add_recurring_trans(uname)
                    run = false
                else
                    "Please only enter 1 or 2"
                end
            elsif trans_details[2] == 0
                delete_trans_by_id(uname, trans_details[0])
                add_single_trans(uname)
                run = false
            end
        when 2
            puts "Please enter the ID of the transaction you would like to delete"
            trans_details = get_trans_by_id(uname)
            if trans_details[2] == 1
                puts "This is part of a recurring transaction. Would you like to delete the entire series, or just this instance?"
                puts "1 - Just this transaction"
                puts "2 - Delete entire series"
                opt = gets.chomp.to_i
                case opt
                when 1
                    delete_trans_by_date_id(uname, trans_details[1], trans_details[0])
                    puts "Deletion successful"
                    run = false
                when 2
                    delete_trans_by_id(uname, trans_details[0])
                    puts "Deletion successful"
                    run = false
                else
                    "Please only enter 1 or 2"
                end
            elsif trans_details[2] == 0
                delete_trans_by_id(uname, trans_details[0])
                puts "Deletion successful"
                run = false
            else
                puts "Something has gone wrong here...sorry"
            end
        else
            puts "Please onter enter 1 or 2"
        end
    end
end
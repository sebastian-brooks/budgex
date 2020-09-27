require_relative("../classes/recurring")
require_relative("../classes/transaction")
require_relative("../classes/user")
require_relative("get_amount")
require_relative("get_date")

def get_transaction_amount
    amount = nil
    opt = nil
    while opt.nil?
        puts "Is this income or an expense?"
        puts "1 - EXPENSE"
        puts "2 - INCOME"
        opt = gets.chomp.to_i
        if opt != 1 && opt != 2
            opt = nil
            puts "Please only enter 1 or 2 as your selection"
        end
    end
    puts "Please enter the amount of the transaction [FORMAT: number or decimal (e.g. $9.25 = 9.25)]"
    amount = get_amount()
    if opt == 1
        amount = -amount
    end
    return amount
end

def get_transaction_description
    description = nil
    while description.nil?
        puts "What is the transaction for?"
        description = gets.chomp
        if description.empty? || description.strip().empty?
            description = nil
            puts "Please enter a description of the transaction"
        end
    end
    return description.gsub(",", "")
end

def get_transaction_category
    category_list = [
        "1 - FOOD/DRINK",
        "2 - TRAVEL",
        "3 - RENT/MORTGAGE",
        "4 - INCOME",
        "5 - UTILITIES",
        "6 - HOUSEHOLD",
        "7 - ENTERTAINMENT",
        "8 - PERSONAL",
        "9 - OTHER"
    ]
    category = nil
    opt = nil
    while opt.nil?
        puts "Please enter a number for the category that best describes the transaction from the list below:"
        category_list.each { |cat| puts cat }
        opt = gets.chomp.to_i
        if ! opt.between?(1,9)
            puts "Invalid selection"
            opt = nil
        end
    end
    category_list.each { |cat|
        if cat[0].to_i == opt
            category = cat[4..-1]
        end
    }
    return category
end

def get_recurrence_interval
    ivls = [
        "1 - Week",
        "2 - Month",
        "3 - Year"
    ]
    interval = nil
    puts "What interval will the transactions occur over?"
    while interval.nil?
        ivls.each { |i| puts i }
        puts "Enter the number for the recurrence intervals"
        interval = gets.chomp
        case interval[0].to_i
        when 1
            interval = :week
        when 2
            interval = :month
        when 3
            interval = :year
        else
            puts "That is not a valid selection - please only enter a number between 1 and 3"
            interval = nil
        end
    end
    return interval
end

def get_recurrence_frequency
    freq = nil
    while freq.nil?
        puts "How frequently do you want this to recur? e.g. every month/week/year (enter 1), every 2 weeks/months/years (enter 2) etc"
        freq = gets.chomp
        if freq == "0"
            freq = ""
        end
        begin
            freq.empty?
        rescue
            puts "That is an invalid frequency - please enter a whole number greater than 0"
            freq = nil
        end
        begin
            Integer(freq)
        rescue
            puts "That is an invalid frequency - please enter a whole number greater than 0"
            freq = nil
        end
    end
    return freq.to_i
end

def add_single_transaction_process(user)
    date = nil
    while date.nil?
        puts "Enter the transaction date [FORMAT: YYYY-MM-DD (e.g. Dec 31st 1995 = 1995-12-31)]"
        puts "Leave blank to use today's date"
        date = get_date()
    end
    amount = get_transaction_amount()
    description = get_transaction_description()
    category = get_transaction_category()
    id = user.generate_new_transaction_id
    new_transaction = Transaction.new(user.username, id, date, amount, description, category)
    new_transaction.add()
    user.sort_transactions
end

def add_recurring_transaction_process(user)
    start_date = nil
    while start_date.nil?
        puts "Please enter the date you want the recurrence to start [FORMAT: YYYY-MM-DD (e.g. Dec 31st 1995 = 1995-12-31)]"
        puts "Leave blank to use today's date"
        start_date = get_date()
    end
    end_date = nil
    while end_date.nil?
        puts "Enter a date when the recurrence will end [FORMAT: YYYY-MM-DD (e.g. Dec 31st 1995 = 1995-12-31)]"
        puts "Leave blank to set maximum (5 years)"
        end_date = get_date(1)
    end
    amount = get_transaction_amount()
    description = get_transaction_description()
    category = get_transaction_category()
    interval = get_recurrence_interval()
    frequency = get_recurrence_frequency()
    id = user.generate_new_transaction_id
    new_recurrence = Recurring.new(user.username, id, start_date, amount, description, category, 1, interval, frequency, end_date)
    new_recurrence.add()
    user.sort_transactions
end

def add_transaction_process(user)
    run = true
    while run
        puts "1 - ADD SINGLE TRANSACTION"
        puts "2 - SETUP RECURRING TRANSACTIONS"
        puts "3 - RETURN TO MAIN MENU"
        opt = gets.chomp.to_i
        case opt
        when 1
            add_single_transaction_process(user)
            run = false
        when 2
            add_recurring_transaction_process(user)
            run = false
        when 3
            run = false
        else
            puts "Please enter a number between 1 and 3"
        end
    end
end
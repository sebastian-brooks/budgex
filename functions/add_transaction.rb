require("tty-font")
require("tty-prompt")
require("rainbow/refinement")
require_relative("../classes/recurring")
require_relative("../classes/transaction")
require_relative("../classes/user")
require_relative("get_amount")
require_relative("get_date")
using Rainbow

def get_transaction_amount
    choices = ["EXPENSE", "INCOME"]
    opt = TTY::Prompt.new.select("Is this income or an expense?", choices)
    puts "Please enter the amount of the transaction [FORMAT: positive whole number or decimal (e.g. 9.25)]"
    amount = get_amount()
    if opt == choices[0]
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
        "FOOD/DRINK",
        "TRAVEL",
        "RENT/MORTGAGE",
        "INCOME",
        "UTILITIES",
        "HOUSEHOLD",
        "ENTERTAINMENT",
        "PERSONAL",
        "OTHER"
    ]
    category = TTY::Prompt.new.select("Select a category that best describes the transaction", category_list)
    return category
end

def get_recurrence_interval
    interval_list = ["WEEK", "MONTH", "YEAR"]
    interval = TTY::Prompt.new.select("What interval will the transactions recur over?", interval_list)
    interval = interval.downcase.to_sym
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
    system "clear"
    font = TTY::Font.new(:starwars)
    puts font.write(" --  BUDGEX  -- ").color(:green)
    run = true
    while run
        choices = [
        "ADD SINGLE TRANSACTION",
        "SETUP RECURRING TRANSACTIONS",
        "RETURN TO MAIN MENU"
        ]
        opt = TTY::Prompt.new.select("", choices)
        case opt
        when choices[0]
            add_single_transaction_process(user)
            run = false
        when choices[1]
            add_recurring_transaction_process(user)
            run = false
        when choices[2]
            run = false
        end
    end
end
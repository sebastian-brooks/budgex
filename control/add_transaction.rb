require_relative("../classes/recurring")
require_relative("../classes/transaction")
require_relative("../classes/user")
require_relative("../functions/clear_screen_leave_logo")
require_relative("../functions/get_amount")
require_relative("../functions/get_date")
require("rainbow/refinement")
require("tty-prompt")
using Rainbow

def get_transaction_description
    description = nil
    while description.nil?
        puts "What is the transaction for?"
        puts "e.g. cat food".color(:darkgray).italic
        description = gets.chomp
        if description.empty? || description.strip().empty?
            description = nil
            puts "DO NOT TAKE ME FOR A FOOL - YOU MUST ENTER A DESCRIPTION".red
        elsif description.length > 50
            description = description.gsub(",", "")[0..49]
        end
    end
    return description
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
    category = TTY::Prompt.new.select("SELECT A CATEGORY THAT BEST DESCRIBES THE TRANSACTION", category_list)
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
        puts "How frequently do you want this to recur?"
        puts "e.g. every month/week/year (enter 1), every 2 weeks/months/years (enter 2) etc".color(:darkgray).italic
        freq = gets.chomp
        if freq == "0"
            freq = ""
        end
        begin
            freq.empty?
        rescue
            puts "That is an invalid frequency - enter a whole number greater than 0".red
            freq = nil
        end
        begin
            Integer(freq)
        rescue
            puts "That is an invalid frequency - enter a whole number greater than 0".red
            freq = nil
        end
    end
    return freq.to_i
end

def check_user_add_preference(user)
    choices = ["ADD ANOTHER TRANSACTION", "RETURN TO MAIN MENU"]
    opt = TTY::Prompt.new.select("", choices)
    add_transaction_process(user) if opt == choices[0]
end

def single_date
    date = nil
    while date.nil?
        puts "ENTER THE TRANSACTION DATE"
        puts "FORMAT: YYYY-MM-DD e.g. Dec 31st 1995 = 1995-12-31".color(:darkgray).italic
        puts "Leave blank to use today's date".cyan.bright
        date = get_date()
    end
    return date
end

def add_single_transaction_process(user)
    clear_screen_print_logo()
    choices = ["TODAY'S DATE", "ENTER A DIFFERENT DATE"]
    opt = TTY::Prompt.new.select("Select the date of the transaction\n", choices)
    if opt == choices[0]
        date = get_date(0)
    else
        date = get_date(2)
    end
    # date = single_date()
    clear_screen_print_logo()
    amount = get_amount(1)
    clear_screen_print_logo()
    description = get_transaction_description()
    clear_screen_print_logo()
    category = get_transaction_category()
    id = user.generate_new_transaction_id
    new_transaction = Transaction.new(user.username, id, date, amount, description, category)
    new_transaction.add()
    user.sort_transactions
    clear_screen_print_logo()
    puts "Transaction added!\n".color(:orange)
    check_user_add_preference(user)
end

def add_recurring_transaction_process(user)
    clear_screen_print_logo()
    choices = ["TODAY'S DATE", "ENTER A DIFFERENT DATE"]
    opt = TTY::Prompt.new.select("Select the starting date of the recurring transaction\n", choices)
    if opt == choices[0]
        start_date = get_date(0)
    else
        start_date = get_date(2)
    end
    clear_screen_print_logo()
    choices = ["SET MAXIMUM FUTURE DATE (5 YEARS FROM TODAY)", "ENTER A DIFFERENT DATE"]
    opt = TTY::Prompt.new.select("Select the starting date of the recurring transaction\n", choices)
    if opt == choices[0]
        end_date = get_date(3)
    else
        end_date = get_date(2)
    end

    clear_screen_print_logo()
    amount = get_amount(1)

    clear_screen_print_logo()
    description = get_transaction_description()
    
    clear_screen_print_logo()
    category = get_transaction_category()
    clear_screen_print_logo()
    interval = get_recurrence_interval()
    clear_screen_print_logo()
    frequency = get_recurrence_frequency()
    id = user.generate_new_transaction_id
    new_recurrence = Recurring.new(user.username, id, start_date, amount, description, category, 1, interval, frequency, end_date)
    new_recurrence.add()
    user.sort_transactions
    clear_screen_print_logo()
    puts "Recurring schedule added!\n".color(:orange)
    check_user_add_preference(user)
end

def add_transaction_process(user)
    clear_screen_print_logo()
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
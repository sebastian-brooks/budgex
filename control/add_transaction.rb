require_relative("../classes/recurring")
require_relative("../classes/transaction")
require_relative("../classes/user")
require_relative("../methods/clear_screen_leave_logo")
require_relative("../methods/get_amount")
require_relative("../methods/get_date")
require_relative("../methods/get_recurrence_schedule")
require_relative("../methods/get_transaction_category")
require_relative("../methods/get_transaction_desc")
require("rainbow/refinement")
require("tty-prompt")
using Rainbow

def check_user_add_preference(user)
    choices = ["ADD ANOTHER TRANSACTION", "RETURN TO MAIN MENU"]
    opt = TTY::Prompt.new.select("", choices)

    add_transaction_process(user) if opt == choices[0]
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
    opt = TTY::Prompt.new.select("Select the end date of the recurring transaction\n", choices)

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
    new_recurrence = Recurring.new(
        user.username,
        id,
        start_date,
        amount,
        description,
        category,
        1,
        interval,
        frequency,
        end_date
    )
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
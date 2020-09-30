require_relative("../methods/clear_screen_leave_logo")
require_relative("../methods/transaction_search")
require_relative("edit_transaction")
require("rainbow/refinement")
require("tty-prompt")
using Rainbow

def transaction_search_process(user)
    run = true
    while run
        clear_screen_print_logo()
        choices = [
            "SEARCH TRANSACTIONS BY DATE",
            "SEARCH TRANSACTIONS BY DATE RANGE",
            "SEARCH TRANSACTIONS BY CATEGORY",
            "SEARCH TRANSACTIONS BY DATE RANGE & CATEGORY",
            "RETURN TO MAIN MENU"
        ]
        opt = TTY::Prompt.new.select("", choices)
        case opt
        when choices[0]
            clear_screen_print_logo()
            table = search_transactions_by_date(user)
        when choices[1]
            clear_screen_print_logo()
            table = search_transactions_by_date_range(user)
        when choices[2]
            clear_screen_print_logo()
            table = search_transactions_by_category(user)
        when choices[3]
            clear_screen_print_logo()
            table = search_transactions_by_category_date_range(user)
        when choices[4]
            run = false
        end
        if opt != choices[4]
            clear_screen_print_logo()
            if table.nil? || table.size == [0,0]
                puts "NO TRANSACTIONS FOUND".color(:orange).bright
            else
                puts "SEARCH RESULTS".color(:crimson).underline
                puts table.render(:ascii)
            end
            choices = ["EDIT/DELETE TRANSACTION", "SEARCH AGAIN", "RETURN TO MAIN MENU"]
            opt = TTY::Prompt.new.select("", choices)
            case opt
            when choices[0]
                edit_transaction_process(user)
                run = false
            when choices[1]
                run = true
            when choices[2]
                run = false
            end
        end
    end
end
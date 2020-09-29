require_relative("clear_screen_leave_logo")
require("rainbow/refinement")
require("tty-prompt")
using Rainbow

def amount_capture
    amount = ""
    while amount.empty?
        puts "ENTER AMOUNT:"
        amount = gets.chomp
        if amount.empty?
            clear_screen_print_logo()
            puts "\nNo amount submitted - please enter an amount\n".color(:orange).bright
        end
    end
    return amount
end

def amount_error_check(amount)
    begin
        Integer(amount)
    rescue
        begin
            Float(amount)
        rescue
            clear_screen_print_logo()
            puts "INVALID AMOUNT\n".red.bright
            puts "Amount must be a whole number or decimal with no currency symbol\n".color(:darkgray).italic
            amount = nil
        end
    end
end

def get_amount(type=1)
    # type arg: 0 for initial balance amount, 1 for transaction amount
    amount = nil
    if type == 0
        while amount.nil?
            puts "Please enter your current bank account balance\n".color(:indigo).bright
            amount = amount_capture()
            amount = amount_error_check(amount)
        end
        amount = amount.to_f
    else
        choices = ["EXPENSE", "INCOME"]
        opt = TTY::Prompt.new.select("Is this income or an expense?", choices)
        while amount.nil?
            amount = amount_capture()
            amount = amount_error_check(amount)
        end
        amount = amount.to_f.abs
        amount = -amount if opt == choices[0]
    end
    return amount
end

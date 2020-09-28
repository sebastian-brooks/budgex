require("rainbow/refinement")
using Rainbow

def get_amount
    amount = nil
    while amount.nil?
        amount = gets.chomp
        if amount[0] == "$"
            amount = amount[1..-1]
        end
        begin
            Integer(amount)
        rescue
            begin
                Float(amount)
            rescue
                puts "\nINVALID AMOUNT. TRY AGAIN.\n".red.bright
                amount = nil
            end
        end
    end
    return amount.to_f.abs
end
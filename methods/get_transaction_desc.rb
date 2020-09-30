require("rainbow/refinement")
using Rainbow

def get_transaction_description
    description = nil
    while description.nil?
        puts "What is the transaction for?"
        puts "e.g. cat food".color(:darkgray).italic
        description = gets.chomp
        if description.empty? || description.strip().empty?
            description = nil
            puts "DO NOT TAKE ME FOR A FOOL - YOU MUST ENTER A DESCRIPTION".color(:orange)
        elsif description.length > 50
            description = description.gsub(",", "")[0..49]
        end
    end
    return description
end
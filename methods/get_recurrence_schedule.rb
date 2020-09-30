require("rainbow/refinement")
require("tty-prompt")
using Rainbow

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

require("date")

def get_date
    date = nil
    while date.nil?
        # puts "Please enter the transaction date [FORMAT: YYYY-MM-DD (e.g. Dec 31st 1995 = 1995-12-31)]"
        puts "Leave blank to use today's date"
        date = gets.chomp
        if date == ""
            date = Date.today.to_s
        else
            begin
                Date.iso8601(date)
            rescue ArgumentError
                date = nil
                puts "That date is not valid."
            end
        end
    end
    if date.length < 10
        date = Date.strptime(date, "%y-%m-%d")
    end
    return date
end
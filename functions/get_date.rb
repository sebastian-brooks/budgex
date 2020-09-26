require("date")

def get_date(pref=0)
    date = gets.chomp
    if date == "" && pref == 0
        date = Date.today.to_s
    elsif date == "" && pref == 1
        date = Date.today.next_year(5).to_s
    else
        begin
            Date.iso8601(date)
        rescue ArgumentError
            date = nil
            puts "That date is not valid."
        end
    end
    if date != nil && date.length < 10
        date = Date.strptime(date, "%y-%m-%d")
    end
    return date
end
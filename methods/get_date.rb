require_relative("clear_screen_leave_logo")
require("date")
require("rainbow/refinement")
using Rainbow

def date_capture
    puts "\nDATE FORMAT: YYYY-MM-DD e.g. Dec 31st 1995 = 1995-12-31\n".color(:darkgray).italic
    puts "ENTER DATE:"
    date = gets.chomp

    begin
        Date.iso8601(date)
    rescue ArgumentError
        clear_screen_print_logo()
        puts "\nINVALID DATE\n".color(:orange).bright
        date = nil
    end

    if date != nil && date.length < 10
        date = Date.strptime(date, "%y-%m-%d")
    end

    return date
end

def get_date(type = 1)
    # type arg: 0 for today's date, 1 for search date, 2 for adding a trans date, 3 for max future date (5 years from today)
    date = nil
    case type
    when 0
        date = Date.today.to_s
    when 1
        while date.nil?
            date = date_capture()
        end
    when 2
        while date.nil?
            date = date_capture()
            if date != nil && (date < Date.today.prev_year(5).to_s || date > Date.today.next_year(5).to_s)
                clear_screen_print_logo()
                puts "Date is outside accepted range of 5 years past or future from today".color(:orange)
                date = nil
            end
        end
    when 3
        date = Date.today.next_year(5).to_s
    end
    
    return date
end

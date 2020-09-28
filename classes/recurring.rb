require_relative("transaction")
require("csv")
require("date")
require("recurrence")

class Recurring < Transaction
    attr_accessor :interval, :frequency, :end_date

    def initialize(username, id, date, amount, description, category, recur=1, interval, frequency, end_date)
        super(username, id, date, amount, description, category, recur)
        @interval = interval
        @frequency = frequency
        @end_date = end_date
        @transaction = {id: @id, date: @date, amount: @amount, description: @description, category: @category, recur: @recur}
    end
    
    def add
        recur = get_recurrence_dates()
        CSV.open("user_transactions/#{@username}_transactions.csv", "a") do |row|
            i = 0
            while i < recur.events.size
                @transaction[:date] = recur.events[i]
                row << @transaction.values.to_a
                i += 1
            end
        end
    end

    # generate all dates used in recurring transaction series
    def get_recurrence_dates
        if @interval == :week
            dw = Date.iso8601(@date).wday
            recur = Recurrence.new(:every => @interval, :on => dw, :interval => @frequency, :until => @end_date)
        elsif @interval == :month
            recur = Recurrence.new(:every => @interval, :on => @date[-2,2].to_i, :interval => @frequency, :until => @end_date)
        else
            recur = Recurrence.new(:every => @interval, :on => [@date[5,2].to_i, @date[-2,2].to_i], :interval => @frequency, :until => @end_date)
        end
        return recur
    end
end

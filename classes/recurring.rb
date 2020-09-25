require "csv"
require "recurrence"
require_relative "transaction"

class Recurring < Transaction
    attr_reader :user, :id, :date, :amount, :description, :category
    def initialize(user, id, date, amount, description, category, recur=1, interval, freq, end_date)
        super(user, id, date, amount, description, category, recur)
        @interval = interval
        @freq = freq
        @end_date = end_date
        @trans = {id: @id, date: @date, amount: @amount, description: @description, category: @category, recur: @recur}
    end
    
    def add
        recur = Recurrence.new(:every => @interval, :on => @date[-2,2].to_i, :interval => @freq, :until => @end_date)
        CSV.open("user_transactions/#{@user}.csv", "a") do |row|
            i = 0
            while i < recur.events.size
                @trans[:date] = recur.events[i]
                row << @trans.values.to_a
                i += 1
            end
        end
        puts "Recurring transaction added"
    end
end
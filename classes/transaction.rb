require "csv"
require "recurrence"

class Transaction
    attr_reader :user, :id, :date, :amount, :description, :category
    def initialize(user, id, date, amount, description, category, recur=0, interval=nil, freq=nil)
        @user = user
        @id = id
        @date = date
        @amount = amount
        @description = description
        @category = category
        @recur = recur
        @interval = interval
        @freq = freq
        @trans = {id: @id, date: @date, amount: @amount, description: @description, category: @category, recur: @recur}
    end

    def add
        CSV.open("user_transactions/#{@user}.csv", "a") do |row|
            row << @trans.values.to_a
        end
        puts "Transaction added"
    end
    
    def recurring
        recur = Recurrence.new(:every => @interval, :on => @date[-2,2].to_i, :interval => @freq, :until => '2021-12-31')
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
class Transaction
    def initialize(date, amount, description, category, recur)
        @date = date
        @amount = amount
        @description = description
        @category = category
        @recur = recur
    end
end
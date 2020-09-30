require("tty-prompt")

def get_transaction_category
    category_list = [
        "FOOD/DRINK",
        "TRAVEL",
        "RENT/MORTGAGE",
        "INCOME",
        "UTILITIES",
        "HOUSEHOLD",
        "ENTERTAINMENT",
        "PERSONAL",
        "OTHER"
    ]
    category = TTY::Prompt.new.select("SELECT A CATEGORY THAT BEST DESCRIBES THE TRANSACTION", category_list)
    
    return category
end
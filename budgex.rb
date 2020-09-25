require_relative("functions/feat_trans_functions")

# Run login/signup
# main menu
#   add trans/recur
#       add trans
#       setup recur
#   search trans/balance
#       search by date/s
#           Edit/delete
#       search by category
#           Edit/delete
#   check zero bal
#       go to date
#           edit
#   delete account
#   logout

username = "test"
puts "Select an option"
puts "1 - Add single transaction"
puts "2 - Setup recurring transaction"
puts "3 - Search transaction by date"
opt = gets.chomp.to_i
if opt == 1
    id = get_id(username)
    t_date = get_trans_date
    t_amt = get_trans_amt
    t_desc = get_trans_desc
    t_cat = get_trans_cat
    new_trans = Transaction.new(username, id, t_date, t_amt, t_desc, t_cat)
    new_trans.add
elsif opt == 2
    id = get_id(username)
    t_date = get_recur_start_date
    t_amt = get_trans_amt
    t_desc = get_trans_desc
    t_cat = get_trans_cat
    t_int = get_interval
    t_freq = get_freq
    t_end = get_recur_end_date
    new_trans = Recurring.new(username, id, t_date, t_amt, t_desc, t_cat, 1, t_int, t_freq, t_end)
    new_trans.add
elsif opt == 3
    search_trans_by_date(username)
else
    puts "You fucked up. I'm outta here!"
end
require_relative("functions/feat_trans_functions")

t_date = get_trans_date
t_amt = get_trans_amt
t_desc = get_trans_desc
t_cat = get_trans_cat

username = "test"
id = get_id(username)

new_trans = Transaction.new(username, id, t_date, t_amt, t_desc, t_cat)

new_trans.add
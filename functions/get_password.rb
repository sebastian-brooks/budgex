require "highline/import"

def get_password
    ask("") { |q| q.echo = "*" }
end
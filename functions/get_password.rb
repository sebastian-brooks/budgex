require "highline/import"

def get_password
    ask("Enter password:") { |q| q.echo = "*" }
end
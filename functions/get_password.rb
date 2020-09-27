require("tty-prompt")

def get_password
    TTY::Prompt.new.mask("")
end
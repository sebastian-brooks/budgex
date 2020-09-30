require("rainbow/refinement")
require("tty-font")
using Rainbow

def clear_screen_print_logo
    system "clear"
    font = TTY::Font.new(:starwars)
    puts font.write(" --  BUDGEX  -- ").color(:green)
end
local hop = require('hop')
local directions = require('hop.hint').HintDirection

local keymap = require("utils/keymap")

local keys = {
    {
        mode = "",
        lhs  = "f",
        rhs  = function ()
            hop.hint_char1({
                direction = directions.AFTER_CURSOR,
                current_line_only = false,
            })
        end,
        opts = {},
    },
    {
        mode = "",
        lhs  = "F",
        rhs  = function ()
            hop.hint_char1({
                direction = directions.BEFORE_CURSOR,
                current_line_only = false,
            })
        end,
        opts = {},
    },
    {
        mode = "",
        lhs  = "t",
        rhs  = function ()
            hop.hint_char1({
                direction = directions.AFTER_CURSOR,
                current_line_only = false,
                hint_offset = -1,
            })
        end,
        opts = {},
    },
    {
        mode = "",
        lhs  = "T",
        rhs  = function ()
            hop.hint_char1({
                direction = directions.BEFORE_CURSOR,
                current_line_only = false,
                hint_offset = -1,
            })
        end,
        opts = {},
    },
}

hop.setup({ keys = 'etovxqpdygfblzhckisuran' })
keymap.map_table(keys, { remap = true })

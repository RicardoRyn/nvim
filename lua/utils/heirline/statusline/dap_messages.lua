local M = {
    condition = function()
        local session = require("dap").session()
        return session ~= nil
    end,
    provider = function()
        return " " .. require("dap").status() .. " "
    end,
    hl = "Debug"
}

return M

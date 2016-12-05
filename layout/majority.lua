--[[

    Author: checkrein
    License: GNU GPL v2

    Relevant API doc:
     http://new.awesomewm.org/apidoc/classes/screen.html

    Awesome WM Layout file
    One large main client at bottom, following are slices at top
    |-----------|
    |  X  |  X  |
    |-----------|
    |           |
    |     X     |
    |           |
    |-----------|

--]]


-- Environment
local beautiful = require("beautiful") -- Allows setting of gaps etc. in theme
local ipairs = ipairs -- Iterator function
local math = math -- Rounding, etc


-- layout.majority
local majority = {}
majority.name = "majority"


function majority.arrange(p)

    -- Local access to clients in current tag
    local clients = p.clients
    local number_clients = #clients
    -- Local access to the workarea - portion of screen where clients are placed
    local workarea = p.workarea

    -- Vertical split ratio
    local major_portion = 0.8
    local minor_portion = 1 - major_portion

    -- Width of previous client
    local client_width_old = 0
    -- X coord of previous client
    local client_x_old = 0

    -- Look at each client in the current tag
    for k, client in ipairs(clients) do

        local client_width -- Client width
        local client_height -- Client height
        local client_y -- Client y
        local client_x -- Client x

        -- Current client's border width
        local border = client.border_width

        -- Single client fills space
        if number_clients == 1 then
            client_width = workarea.width
            client_height = workarea.height
            client_x = 0
            client_y = 0
        else
            -- Highest indexed client is first added
            if k == number_clients then
                client_width = workarea.width
                client_height = workarea.height * major_portion
                client_x = 0
                client_y = workarea.height * minor_portion
            -- Other clients should be split across the top area
            else
                client_width = workarea.width / ( number_clients - 1)
                client_height = workarea.height * minor_portion
                client_x = client_width_old + client_x_old
                client_y = 0
                client_width_old = client_width
                client_x_old = client_x
            end
        end

        -- Determine geometry for current client
        local geo = {
            -- Borders are outside the client window, so must compensate
            width = client_width - border * 2,
            height = client_height - border * 2,
            x = client_x,
            y = client_y
        }

        -- Apply geometry to the current client
        client:geometry(geo)

    end
end


return majority
